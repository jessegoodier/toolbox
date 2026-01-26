#!/usr/bin/env python3
import json
import sys
import datetime
import os
from pathlib import Path


def format_severity(severity):
    icons = {
        "CRITICAL": "🔴",
        "HIGH": "🟠",
        "MEDIUM": "🟡",
        "LOW": "🟢",
        "UNKNOWN": "⚪",
    }
    return f"{icons.get(severity, '')} {severity}"


def process_trivy_json(data):
    """Process a single trivy JSON result and return vulnerabilities."""
    vulns_by_target = []

    if "Results" in data:
        for result in data["Results"]:
            target = result.get("Target", "Unknown Target")
            vulns = result.get("Vulnerabilities", [])

            if vulns:
                vulns_by_target.append({"target": target, "vulnerabilities": vulns})

    return vulns_by_target


def format_vulnerabilities(vulns_by_target):
    """Format vulnerabilities into markdown table rows."""
    output = []
    vuln_count = 0

    for item in vulns_by_target:
        target = item["target"]
        vulns = item["vulnerabilities"]

        output.append(f"### Target: {target}\n")
        output.append("| Package | ID | Severity | Installed | Fixed In | Title |")
        output.append("| --- | --- | --- | --- | --- | --- |")

        for vuln in vulns:
            vuln_count += 1
            pkg_name = vuln.get("PkgName", "N/A")
            vuln_id = vuln.get("VulnerabilityID", "N/A")
            severity = format_severity(vuln.get("Severity", "UNKNOWN"))
            installed_version = vuln.get("InstalledVersion", "N/A")
            fixed_version = vuln.get("FixedVersion", "N/A")
            title = vuln.get("Title", "No description available")

            # Sanitize title to avoid breaking tables
            title = title.replace("|", "/")

            # Make ID a link if PrimaryURL is present
            if "PrimaryURL" in vuln:
                vuln_id = f"[{vuln_id}]({vuln['PrimaryURL']})"

            output.append(
                f"| {pkg_name} | {vuln_id} | {severity} | {installed_version} | {fixed_version} | {title} |"
            )

        output.append("\n")

    return output, vuln_count


def main():
    if len(sys.argv) < 2:
        print("Usage: format_cve_report.py <trivy_json_file_or_directory>")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    report_date = datetime.date.today().strftime("%Y-%m-%d")
    output = [f"# CVE Audit Report - {report_date}\n"]

    total_vulnerability_count = 0

    # Handle directory with multiple JSON files (one per image)
    if input_path.is_dir():
        json_files = sorted(input_path.glob("*.json"))

        for json_file in json_files:
            image_name = json_file.stem  # e.g., "toolbox-common"

            try:
                with open(json_file, "r") as f:
                    data = json.load(f)
            except Exception as e:
                output.append(f"## {image_name}\n")
                output.append(f"Error reading results: {e}\n")
                continue

            vulns_by_target = process_trivy_json(data)

            output.append(f"## {image_name}\n")

            if vulns_by_target:
                formatted, count = format_vulnerabilities(vulns_by_target)
                output.extend(formatted)
                total_vulnerability_count += count
            else:
                output.append("No fixable HIGH or CRITICAL vulnerabilities found.\n")

            output.append("\n")

    # Handle single JSON file (backwards compatibility)
    else:
        try:
            with open(input_path, "r") as f:
                data = json.load(f)
        except Exception as e:
            print(f"Error reading JSON file: {e}")
            sys.exit(1)

        vulns_by_target = process_trivy_json(data)

        if vulns_by_target:
            formatted, count = format_vulnerabilities(vulns_by_target)
            output.extend(formatted)
            total_vulnerability_count += count

    if total_vulnerability_count == 0:
        # Clear previous output if no vulns across all images
        output = [f"# CVE Audit Report - {report_date}\n"]
        output.append("✅ No fixable HIGH or CRITICAL vulnerabilities found.\n")

    print(
        "".join([line + "\n" if not line.endswith("\n") else line for line in output])
    )


if __name__ == "__main__":
    main()
