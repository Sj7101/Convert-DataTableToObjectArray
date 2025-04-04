# Convert-DataTableToObjectArray

## Overview

`Convert-DataTableToObjectArray` is a PowerShell function that converts a `.NET` `System.Data.DataTable` object into an array of `PSCustomObject`s. This is particularly useful when working with SQL query results retrieved via ADO.NET in PowerShell v5.1 (no external modules required).

This function includes built-in handling for SQL `NULL` values (represented as `[DBNull]::Value`), converting them to native PowerShell `$null`.

---

## Features

- Converts each row in a `DataTable` into a `PSCustomObject`
- Preserves column names as property names
- Converts `[DBNull]::Value` to `$null`
- Returns a clean object array suitable for further processing or JSON serialization

---

## Requirements

- PowerShell 5.1
- Native .NET objects (no external dependencies)
- A valid `System.Data.DataTable` object

---

## Function Definition

```powershell
function Convert-DataTableToObjectArray {
    param (
        [Parameter(Mandatory)]
        [System.Data.DataTable]$DataTable
    )

    $objectArray = @()

    foreach ($row in $DataTable.Rows) {
        $obj = [PSCustomObject]@{}
        foreach ($col in $DataTable.Columns) {
            $colName = $col.ColumnName
            $value = $row[$colName]

            if ($value -eq [DBNull]::Value) {
                $value = $null
            }

            $obj | Add-Member -NotePropertyName $colName -NotePropertyValue $value
        }
        $objectArray += $obj
    }

    return $objectArray
}
