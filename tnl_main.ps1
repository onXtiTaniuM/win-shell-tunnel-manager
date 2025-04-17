param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("-list", "-start", "-stop")]
    [string]$Command,
    [string]$FileName
)

# 환경변수에서 스크립트 경로 읽기
$scriptPath = "C:\Scripts\tunnel"
if (-not (Test-Path -Path $scriptPath -PathType Container)) {
    Write-Error "기본 지정된 경로가 존재하지 않습니다: $scriptPath"
    exit 1
}

switch ($Command) {
    "-list" {
        # 지정 경로 하위의 .ps1 파일 목록 출력
        Get-ChildItem -Path $scriptPath -Filter *.ps1 -File -Name
    }
    "-start" {
        if (-not $FileName) {
            Write-Error "-start 명령에는 파일명을 입력해야 합니다."
            exit 1
        }
        $targetFile = Join-Path $scriptPath $FileName ".ps1"
        if (-not (Test-Path $targetFile)) {
            Write-Error "지정한 파일이 존재하지 않습니다: $targetFile"
            exit 1
        }
        # 스크립트 실행
        Write-Host "실행: $targetFile"
        & $targetFile
    }
    "-stop" {
        Write-Host "미구현"
    }
    "-help" {
        Write-Host @"
사용법: tnl <명령> [파일명]
-list           : 스크립트 목록 출력
-start <파일명> : 지정 스크립트 실행
-help           : 도움말 표시
"@
    }
    default {
        Write-Host "알 수 없는 명령입니다. tnl -help로 사용법을 확인하세요."
    }
}