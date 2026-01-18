#!/usr/bin/env python3
import json
import sys
import datetime


def format_severity(severity):
    icons = {
        "CRITICAL": "🔴",
        "HIGH": "🟠",
        "MEDIUM": "🟡",
        "LOW": "abc",
        "UNKNOWN": "aaa",
    }
    return f"{icons.get(severity, '')} {severity}"


def main():
    if len(sys.argv) < 2:
        print("Usage: format_cve_report.py <trivy_json_file>")
        sys.exit(1)

    input_file = sys.argv[1]

    try:
        with open(input_file, "r") as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        sys.exit(1)

    report_date = datetime.date.today().strftime("%Y-%m-%d")
    output = [f"# CVE Audit Report - {report_date}\n"]

    vulnerability_count = 0

    if "Results" in data:
        for result in data["Results"]:
            target = result.get("Target", "Unknown Target")
            vulns = result.get("Vulnerabilities", [])

            if not vulns:
                continue

            output.append(f"## Target: {target}\n")
            output.append("| Package | ID | Severity | Installed | Fixed In | Title |")
            output.append("| --- | --- | --- | --- | --- | --- |")

            for vuln in vulns:
                vulnerability_count += 1
                pkg_name = vuln.get("PkgName", "N/A")
                vuln_id = vuln.get("VulnerabilityID", "N/A")
                severity = format_severity(vuln.get("Severity", "UNKNOWN"))
                installed_version = vuln.get("InstalledVersion", "N/A")
                fixed_version = vuln.get("FixedVersion", "N/A")
                title = vuln.get("Title", "No description available")

                # Sanitize title to avoid breaking tables (replace pipes)
                title = title.replace("|", "/")

                # Make ID a link if PrimaryURL is present
                if "PrimaryURL" in vuln:
                    vuln_id = f"[{vuln_id}]({vuln['PrimaryURL']})"

                output.append(
                    f"| {pkg_name} | {vuln_id} | {severity} | {installed_version} | {fixed_version} | {title} |"
                )

            output.append("\n")

    if vulnerability_count == 0:
        output.append("No fixable HIGH or CRITICAL vulnerabilities found.")

    print(
        "".join([line + "\n" if not line.endswith("\n") else line for line in output])
    )


if __name__ == "__main__":
    main()
