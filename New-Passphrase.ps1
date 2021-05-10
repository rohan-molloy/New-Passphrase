<#
.SYNOPSIS
    Generate a passphrase from a wordlist
.DESCRIPTION
    Generates a passphrase from selecting a random permutation of words from a list
    By default, each word is dash delimited. A number is appended to the passphrase
    With a 1000 word list, there are over 993 trilion possible permutations.
.PARAMETER InputFile
    Path to the word list
.PARAMETER Delimiter
    String to use for seperating words
.PARAMETER Words
    Number of words to use for the passphrase
.PARAMETER AsSecureString
    Return the output as a secure string
.PARAMETER RandomNumberMin
    Minimum random number to append on the end
.PARAMETER RandomNumberMax
    Maxmimum random number to append on the end
.EXAMPLE
    PS> New-Passphrase -InputFile words.txt
    Future-School-Pick-Guy-652
.Example
    PS> New-Passphrase -InputFile words.txt -RandomNumberMin 0 -RandomNumberMax 9999
    Treat-Various-Contain-Item-4330
.Example
    PS> New-Passphrase -InputFile words.txt -Words 8 -RandomNumberMin 0 -RandomNumberMax 9999
    Of-Operation-Recent-Campaign-Political-Expect-Job-Report-8299
.NOTES
    Author: Rohan Molloy
#>
function New-Passphrase
{
    [CmdletBinding()]
    param
    (
           [Parameter(Mandatory=$true)][string]$InputFile,
           [string]$Delimiter = "-",
           [Int]$Words = 4,
           [switch]$AsSecureString = $false,
           [Int]$RandomNumberMin = 100,
           [Int]$RandomNumberMax = 1000
    )
    BEGIN
    {
       if ( -not (Test-Path $InputFile) ) {
        throw [System.IO.FileNotFoundException] "Input File not found"
       }
       $WordList = ((Get-Content $InputFile) -replace "`r","").split("`n")
       if ($Words -lt 2 -or $Words -gt ($WordList.Count/2)) {
           Throw New-Object System.ArgumentException "Invalid number of words"
       }
       if($RandomNumberMin -ge $RandomNumberMax -or $RandomNumberMin -lt 0 -or $RandomNumberMax -lt 1) {
           Throw New-Object System.ArgumentException "Invalid range for random numbers"
       } 
    }
    PROCESS
    {
       if($AsSecureString) {
        $password=(($WordList | Get-Random -Count $Words) -join $Delimiter)+$Delimiter+(Get-Random -Minimum $RandomNumberMin -Maximum $RandomNumberMax) | ConvertTo-SecureString -Force -AsPlainText
       } else {
        $password=(($WordList | Get-Random -Count $Words) -join $Delimiter)+$Delimiter+(Get-Random -Minimum $RandomNumberMin -Maximum $RandomNumberMax)
       }
    }
    END
    {
      return $password
    }
}