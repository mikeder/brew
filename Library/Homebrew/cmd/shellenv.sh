#:  * `shellenv`
#:
#:  Print export statements. When run in a shell, this installation of Homebrew will be added to your `PATH`, `MANPATH`, and `INFOPATH`.
#:
#:  The variables `HOMEBREW_PREFIX`, `HOMEBREW_CELLAR` and `HOMEBREW_REPOSITORY` are also exported to avoid querying them multiple times.
#:  The variable `HOMEBREW_SHELLENV_PREFIX` will be exported to avoid adding duplicate entries to the environment variables.
#:  Consider adding evaluation of this command's output to your dotfiles (e.g. `~/.profile`, `~/.bash_profile`, or `~/.zprofile`) with: `eval "$(brew shellenv)"`

# HOMEBREW_CELLAR and HOMEBREW_PREFIX are set by extend/ENV/super.rb
# HOMEBREW_REPOSITORY is set by bin/brew
# shellcheck disable=SC2154
homebrew-shellenv() {
  if [[ "${HOMEBREW_SHELLENV_PREFIX}" == "${HOMEBREW_PREFIX}" ]] &&
     [[ "$(PATH="${HOMEBREW_PATH}" command -v brew)" == "${HOMEBREW_PREFIX}/bin/brew" ]]
  then
    return
  fi

  case "$(/bin/ps -p "${PPID}" -c -o comm=)" in
    fish | -fish)
      echo "set -gx HOMEBREW_PREFIX \"${HOMEBREW_PREFIX}\";"
      echo "set -gx HOMEBREW_CELLAR \"${HOMEBREW_CELLAR}\";"
      echo "set -gx HOMEBREW_REPOSITORY \"${HOMEBREW_REPOSITORY}\";"
      echo "set -gx HOMEBREW_SHELLENV_PREFIX \"${HOMEBREW_PREFIX}\";"
      echo "set -q PATH; or set PATH ''; set -gx PATH \"${HOMEBREW_PREFIX}/bin\" \"${HOMEBREW_PREFIX}/sbin\" \$PATH;"
      echo "set -q MANPATH; or set MANPATH ''; set -gx MANPATH \"${HOMEBREW_PREFIX}/share/man\" \$MANPATH;"
      echo "set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH \"${HOMEBREW_PREFIX}/share/info\" \$INFOPATH;"
      ;;
    csh | -csh | tcsh | -tcsh)
      echo "setenv HOMEBREW_PREFIX ${HOMEBREW_PREFIX};"
      echo "setenv HOMEBREW_CELLAR ${HOMEBREW_CELLAR};"
      echo "setenv HOMEBREW_REPOSITORY ${HOMEBREW_REPOSITORY};"
      echo "setenv HOMEBREW_SHELLENV_PREFIX ${HOMEBREW_PREFIX};"
      echo "setenv PATH ${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:\$PATH;"
      echo "setenv MANPATH ${HOMEBREW_PREFIX}/share/man\`[ \${?MANPATH} == 1 ] && echo \":\${MANPATH}\"\`:;"
      echo "setenv INFOPATH ${HOMEBREW_PREFIX}/share/info\`[ \${?INFOPATH} == 1 ] && echo \":\${INFOPATH}\"\`;"
      ;;
    pwsh | -pwsh)
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_PREFIX','${HOMEBREW_PREFIX}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_CELLAR','${HOMEBREW_CELLAR}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_REPOSITORY','${HOMEBREW_REPOSITORY}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('HOMEBREW_SHELLENV_PREFIX','${HOMEBREW_PREFIX}',[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('PATH',\$('${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:'+\$ENV:PATH),[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('MANPATH',\$('${HOMEBREW_PREFIX}/share/man'+\$(if(\${ENV:MANPATH}){':'+\${ENV:MANPATH}})+':'),[System.EnvironmentVariableTarget]::Process)"
      echo "[System.Environment]::SetEnvironmentVariable('INFOPATH',\$('${HOMEBREW_PREFIX}/share/info'+\$(if(\${ENV:INFOPATH}){':'+\${ENV:INFOPATH}})),[System.EnvironmentVariableTarget]::Process)"
      ;;
    *)
      echo "export HOMEBREW_PREFIX=\"${HOMEBREW_PREFIX}\";"
      echo "export HOMEBREW_CELLAR=\"${HOMEBREW_CELLAR}\";"
      echo "export HOMEBREW_REPOSITORY=\"${HOMEBREW_REPOSITORY}\";"
      echo "export HOMEBREW_SHELLENV_PREFIX=\"${HOMEBREW_PREFIX}\";"
      echo "export PATH=\"${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin\${PATH+:\$PATH}\";"
      echo "export MANPATH=\"${HOMEBREW_PREFIX}/share/man\${MANPATH+:\$MANPATH}:\";"
      echo "export INFOPATH=\"${HOMEBREW_PREFIX}/share/info:\${INFOPATH:-}\";"
      ;;
  esac
}
