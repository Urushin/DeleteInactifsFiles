<#
.SYNOPSIS
    Supprime les fichiers inactifs dans un dossier spécifié après un certain nombre de jours.

.DESCRIPTION
    Ce script PowerShell supprime les fichiers dans un dossier donné qui n'ont pas été modifiés depuis un nombre de jours spécifié. Il journalise les fichiers supprimés ainsi que les éventuelles erreurs rencontrées lors de la suppression.

.PARAMETER FolderPath
    Chemin du dossier à nettoyer. Par défaut, il est défini sur le dossier de téléchargements de l'utilisateur.

.PARAMETER DaysInactive
    Nombre de jours d'inactivité avant suppression des fichiers. Par défaut, il est défini sur 7 jours.

.EXAMPLE
    .\NettoyageTelechargements.ps1 -FolderPath "C:\Users\VotreNom\Downloads" -DaysInactive 10
#>

param (
    [Parameter(Mandatory = $false, HelpMessage = "Chemin du dossier à nettoyer.")]
    [ValidateNotNullOrEmpty()]
    [string]$FolderPath = "$env:USERPROFILE\Downloads",

    [Parameter(Mandatory = $false, HelpMessage = "Nombre de jours d'inactivité avant suppression.")]
    [ValidateRange(1, 365)]
    [int]$DaysInactive = 7
)

# Fonction de journalisation
function Log-Message {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$Level] - $Message"

    # Afficher le message dans la console
    switch ($Level) {
        "INFO" { Write-Output $logEntry }
        "WARN" { Write-Warning $Message }
        "ERROR" { Write-Error $Message }
    }

    # Écrire le message dans le fichier de log
    $logFile = Join-Path -Path $FolderPath -ChildPath "NettoyageLog.txt"
    try {
        $logEntry | Out-File -FilePath $logFile -Append -Encoding UTF8
    } catch {
        Write-Error "Impossible d'écrire dans le fichier de log : $_"
    }
}

# Validation du chemin du dossier
if (-Not (Test-Path -Path $FolderPath)) {
    Log-Message -Message "Le chemin spécifié n'existe pas : $FolderPath" -Level "ERROR"
    exit 1
}

# Calcul de la date limite
$CurrentDate = Get-Date
$LimitDate = $CurrentDate.AddDays(-$DaysInactive)

Log-Message -Message "Début du nettoyage dans le dossier : $FolderPath avec une limite d'inactivité de $DaysInactive jours."

# Récupérer les fichiers inactifs
try {
    $FilesToDelete = Get-ChildItem -Path $FolderPath -File | Where-Object { $_.LastWriteTime -lt $LimitDate }
    Log-Message -Message "Nombre de fichiers à supprimer : $($FilesToDelete.Count)"
} catch {
    Log-Message -Message "Erreur lors de la récupération des fichiers : $_" -Level "ERROR"
    exit 1
}

# Supprimer les fichiers
foreach ($file in $FilesToDelete) {
    try {
        Remove-Item -Path $file.FullName -Force -ErrorAction Stop
        Log-Message -Message "Supprimé : $($file.FullName)" -Level "INFO"
    } catch {
        Log-Message -Message "Erreur lors de la suppression de $($file.FullName) : $_" -Level "ERROR"
    }
}

Log-Message -Message "Nettoyage terminé."

# Optionnel : Sortie des fichiers supprimés
# $FilesToDelete | Select-Object FullName
