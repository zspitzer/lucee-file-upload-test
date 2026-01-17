# Lucee File Upload Test

Testing file upload behaviour across different Lucee versions and operating systems.

## Issue

From the Lucee dev forum: [Can Lucee mimic ColdFusion's file upload?](https://dev.lucee.org/t/can-lucee-mimic-coldfusions-file-upload/17019)

**Problem:** In ColdFusion, you can specify just a directory path as the destination for file uploads:

```cfml
<cffile action="upload" fileField="imageField"
destination="/path/to/images/folder" nameConflict="makeUnique">
```

In Lucee 6.2.1.122, this allegedly creates a subdirectory instead of placing the file directly in the specified folder.

## Test Matrix

This repository tests file upload behaviour across:

- **Operating Systems:** Ubuntu (Linux), Windows
- **Lucee Versions:** 7.0/snapshot, 6.2/snapshot, 6.2/stable
- **Java Version:** 21

## Test Scenarios

The tests cover four scenarios:

1. **Existing directory, no trailing slash** - `destination="/path/to/uploads"`
2. **Existing directory, WITH trailing slash** - `destination="/path/to/uploads/"`
3. **Non-existing directory, no trailing slash** - `destination="/path/to/uploads2"`
4. **Non-existing directory, WITH trailing slash** - `destination="/path/to/uploads3/"`

## Files

- [test.cfm](test.cfm) - Main test runner that uses cfhttp to upload files
- [upload.cfm](upload.cfm) - Upload handler that processes file uploads
- [.github/workflows/test.yml](.github/workflows/test.yml) - GitHub Actions workflow

## Running Tests

### Locally with LuCLI

Install LuCLI:

```bash
# Linux/Mac
curl -fsSL https://raw.githubusercontent.com/cybersonic/LuCLI/main/install.sh | sh

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cybersonic/LuCLI/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

Start server and run tests:

```bash
lucli server start --port 8888
curl http://localhost:8888/test.cfm
lucli server stop
```

### Via GitHub Actions

Tests run automatically on push/PR, or manually via workflow dispatch with custom Lucee versions.

## Expected Results

All tests should show files being placed directly in the specified directory with their original filename, not in a subdirectory.

Example output:

```
Test 1 - SUCCESS
Destination specified: /path/to/uploads
File saved to: /path/to/uploads/testfile.txt
```

## Initial Test Results (Lucee 7.0.2.37-SNAPSHOT)

All scenarios work correctly:

- Files are placed in the destination directory with their original filename
- No unwanted subdirectories are created
- Both existing and non-existing directories are handled properly

This suggests the issue may have been fixed in Lucee 7.0, or only affects specific path types or configurations.
