<#
.SYNOPSIS
    Converts a .NET DataTable into an array of PowerShell PSCustomObjects.

.DESCRIPTION
    This function takes a System.Data.DataTable object and converts each row into a PSCustomObject.
    It preserves column names as object properties and safely converts SQL NULL values (represented as [DBNull]::Value)
    into native PowerShell $null values.

.PARAMETER DataTable
    The System.Data.DataTable to convert. This must be a valid table, typically returned from an ADO.NET SQL query.

.OUTPUTS
    [PSCustomObject[]]
    An array of PowerShell objects representing each row of the input DataTable.

.EXAMPLE
    $dataTable = Invoke-DataQuerySQL -Server "MyServer" -Database "MyDB" -Query "SELECT * FROM MyTable" -Operation "Get"
    $results = Convert-DataTableToObjectArray -DataTable $dataTable

    Converts the query result into a usable array of custom objects.

.EXAMPLE
    $json = Convert-DataTableToObjectArray -DataTable $table | ConvertTo-Json -Depth 5

    Useful for converting SQL results to JSON for web APIs or SQL insert logging.

.NOTES
    Author  : Shawn J Hanlon
    Version : 1.0
    Date    : 04/01/2025
    Compatible with PowerShell 5.1 (no external dependencies)
#>


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

            # Replace DBNull with $null
            if ($value -eq [DBNull]::Value) {
                $value = $null
            }

            $obj | Add-Member -NotePropertyName $colName -NotePropertyValue $value
        }
        $objectArray += $obj
    }

    return $objectArray
}
