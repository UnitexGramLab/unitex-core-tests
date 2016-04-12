#!/usr/bin/env bash
# =============================================================================
# Unitex/GramLab Core Integration Tests
# https://github.com/UnitexGramLab/unitex-core-tests
# =============================================================================
# Copyright (C) 2016 Université Paris-Est Marne-la-Vallée <unitex-devel@univ-mlv.fr>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
#
# cristian.martinez@univ-paris-est.fr (martinec)
#
# =============================================================================
# Script code must be ShellCheck-compliant for information about how to run
# ShellCheck locally @see http://www.shellcheck.net/about.html
# e.g shellcheck -s sh setup
# =============================================================================
# seconds since 1970-01-01 00:00:00 UTC
START_SECONDS=$(date +%s)
# Start date timestamp e.g. Fri Mar 22 00:10:29 CET 2013
TIMESTAMP_START_C="$(date +'%F %T %z')"
# =============================================================================
# Constants
# =============================================================================
UNITEX_TEST_SCRIPT_NAME=$(basename -- "$0")                 # This script name
UNITEX_TEST_CODENAME="Unitex/GramLab Core Integration Tests"
UNITEX_TEST_REPOSITORY="https://github.com/UnitexGramLab/unitex-core-tests"
UNITEX_CORE_REPOSITORY="https://github.com/UnitexGramLab/unitex-core"
# =============================================================================
# Script working directory
# =============================================================================
# Working directory snippet from @source http://stackoverflow.com/a/17744637/2042871
UNITEX_TEST_SCRIPT_FILE=$(cd -P -- "$(dirname -- "$0")" && pwd -P) &&\
UNITEX_TEST_SCRIPT_FILE="$UNITEX_TEST_SCRIPT_FILE/$UNITEX_TEST_SCRIPT_NAME"

# Resolve symlinks snippet from @source http://stackoverflow.com/a/697552/2042871
while [ -h "$UNITEX_TEST_SCRIPT_FILE" ]; do
    UNITEX_TEST_SCRIPT_DIR=$(dirname -- "$UNITEX_TEST_SCRIPT_FILE")
    UNITEX_TEST_SCRIPT_SYM=$(readlink   "$UNITEX_TEST_SCRIPT_FILE")
    UNITEX_TEST_SCRIPT_FILE="$(cd "$UNITEX_TEST_SCRIPT_DIR"  &&\
                                  cd "$(dirname  -- "$UNITEX_TEST_SCRIPT_SYM")" &&\
                                 pwd)/$(basename -- "$UNITEX_TEST_SCRIPT_SYM")"
done  # [ -h "$UNITEX_TEST_SCRIPT_FILE" ]
# =============================================================================
# Set-up working directory
UNITEX_TEST_SCRIPT_BASEDIR="$(dirname  -- "$UNITEX_TEST_SCRIPT_FILE")"
# Default workspace is the working directory
UNITEX_TEST_LOG_WORKSPACE="$UNITEX_TEST_SCRIPT_BASEDIR"
# =============================================================================
# Script name
UNITEX_TEST_SCRIPT_NAME=${0##*/}
# =============================================================================
# Minimal Bash version
UNITEX_TEST_MINIMAL_BASH_VERSION_STRING="4.2.0"
UNITEX_TEST_MINIMAL_BASH_VERSION_NUMBER=$((4 * 100000 + 2 * 1000 + 0))
# =============================================================================
# Default trap signals
# shellcheck disable=SC2034
UNITEX_TEST_SIGNAL_INT=INT
# shellcheck disable=SC2034
UNITEX_TEST_SIGNAL_QUIT=QUIT
# shellcheck disable=SC2034
UNITEX_TEST_SIGNAL_TERM=TERM
# shellcheck disable=SC2034
UNITEX_TEST_SIGNAL_EXIT=EXIT
# =============================================================================
# Default commands
UNITEX_TEST_TOOL_BIN="UnitexToolLogger"
UNITEX_TEST_TOOL_PRINTF=$( command -v printf        ||\
                           command -v /bin/echo     ||\
                           command -v /usr/ucb/echo ||\
                           command -v echo          || echo "echo" )
UNITEX_TEST_TOOL_VALGRIND="valgrind"
# =============================================================================
# Reset in case getopts has been used previously in the shell
# This is from @source http://bash.cumulonim.biz/BashFAQ%282f%29035.html
OPTIND=1
# =============================================================================
# shellcheck disable=SC2034
{
# Default constants
UNITEX_TEST_LINE_STRING=$(head -c 80 < /dev/zero | tr '\0' '=' || echo "")
# VT100 Colors
UNITEX_TEST_CONSOLE_COLOR_BLACK="\033[22;30m"
UNITEX_TEST_CONSOLE_COLOR_BLUE="\033[22;34m"
UNITEX_TEST_CONSOLE_COLOR_BROWN="\033[22;33m"
UNITEX_TEST_CONSOLE_COLOR_CYAN="\033[22;36m"
UNITEX_TEST_CONSOLE_COLOR_DARKGRAY="\033[01;30m"
UNITEX_TEST_CONSOLE_COLOR_GRAY="\033[22;37m"
UNITEX_TEST_CONSOLE_COLOR_GREEN="\033[22;32m"
UNITEX_TEST_CONSOLE_COLOR_LIGHTBLUE="\033[01;34m"
UNITEX_TEST_CONSOLE_COLOR_LIGHTCYAN="\033[01;36m"
UNITEX_TEST_CONSOLE_COLOR_LIGHTGREEN="\033[01;32m"
UNITEX_TEST_CONSOLE_COLOR_LIGHTMAGENTA="\033[01;35m"
UNITEX_TEST_CONSOLE_COLOR_LIGHTRED="\033[01;31m"
UNITEX_TEST_CONSOLE_COLOR_MAGENTA="\033[22;35m"
UNITEX_TEST_CONSOLE_COLOR_RED="\033[22;31m"
UNITEX_TEST_CONSOLE_COLOR_WHITE="\033[01;37m"
UNITEX_TEST_CONSOLE_COLOR_YELLOW="\033[01;33m"
# VT100 common
UNITEX_TEST_CONSOLE_CLEAR_CURRENT_LN=" \r\033[2K"
UNITEX_TEST_CONSOLE_RESET="\033[0m"
}
# =============================================================================
# Counters
UNITEX_TEST_COMMAND_EXECUTION_ERROR_COUNT=0
UNITEX_TEST_COMMAND_EXECUTION_COUNT=0
UNITEX_TEST_LOG_MESSAGE_COUNT=0
UNITEX_TEST_FINISH_WITH_ERROR_COUNT=0
UNITEX_TEST_LOG_LEVEL_COUNTER=(0 0 0 0 0 0 0 0)
# =============================================================================
# shellcheck disable=SC2034
UNITEX_TEST_CURRENT_STDOUT=/dev/stdout
# shellcheck disable=SC2034
UNITEX_TEST_PREVIOUS_STDOUT=/dev/stdout
# =============================================================================
# Default variables
UNITEX_TEST_LOG_FILE_EXT=".log"
UNITEX_TEST_ULP_EXTENSION=".ulp"
UNITEX_TEST_TARGET="$UNITEX_TEST_SCRIPT_BASEDIR"
UNITEX_TEST_COMMAND_LINE_LOG_FILE=""
# =============================================================================
# Default params
UNITEX_TEST_MEMORY_ERRORS=0
UNITEX_TEST_NON_REGRESSION=1
UNITEX_TEST_PRINT_EXECUTION_LOGS=0
UNITEX_TEST_DIFF_OUTPUT_FILES=0
UNITEX_TEST_USE_ANSI_COLORS=1
UNITEX_TEST_DIFF_COLORS="--color"
UNITEX_TEST_VERBOSITY=1
UNITEX_TEST_EXECUTION_LOG_MESSAGE_WIDTH=119
# =============================================================================
# Default error codes
UNITEX_TEST_DEFAULT_ERROR_CODE=1
UNITEX_TEST_MEMORY_ERROR_CODE=66
# has defined on unitex-core/Error.h
UNITEX_TEST_RUNLOG_COMPARE_ERROR_CODE=80
UNITEX_TEST_RUNLOG_WARNING_CODE=79
# =============================================================================
# Portable echo function
# @source http://www.etalabs.net/sh_tricks.html
# =============================================================================
echo () (
  fmt=%s end=\\n IFS=" "

  while [ $# -gt 1 ] ; do
   case "$1" in
    [!-]*|-*[!ne]*) break;;
    *ne*|*en*) fmt=%b end=;;
    *n*) end=;;
    *e*) fmt=%b;;
   esac
   shift
  done

  $UNITEX_TEST_TOOL_PRINTF "$fmt$end" "$*"
)
# =============================================================================
# Portable readlink -f
# @source http://stackoverflow.com/a/1116890/2042871
# =============================================================================
readlinkf() {
  TARGET_FILE="$1"

  cd "$(dirname "$TARGET_FILE")"
  TARGET_FILE=$(basename "$TARGET_FILE")

  # Iterate down a (possible) chain of symlinks
  while [ -L "$TARGET_FILE" ]
  do
      TARGET_FILE=$(readlink "$TARGET_FILE")
      cd "$(dirname "$TARGET_FILE")"
      TARGET_FILE=$(basename "$TARGET_FILE")
  done

  # Compute the canonicalized name by finding the physical path 
  # for the directory we're in and appending the target file.
  PHYS_DIR=$(pwd -P)
  RESULT="$PHYS_DIR/$TARGET_FILE"
  printf "%s" "$RESULT"
}
# =============================================================================
# check bash version
# ATTENTION NEVER USE LOG FUNCTIONS FROM HERE !
check_bash_version() {
  local -r bash_version_string="${BASH_VERSION%%[^0-9.]*}"
  local -r bash_version_major="${BASH_VERSINFO[0]}"
  local -r bash_version_minor="${BASH_VERSINFO[1]}"
  local -r bash_version_patch="${BASH_VERSINFO[2]}"

  #          $bash_version_major * (major <= +INF)
  # 100000 + $bash_version_minor * (minor <= 99)
  # 1000   + $bash_version_patch   (patch <= 999)
  local -r bash_version_number=$((bash_version_major * 100000 + bash_version_minor * 1000 + bash_version_patch))

  # check bash version
  if [ "$bash_version_number" -lt "$UNITEX_TEST_MINIMAL_BASH_VERSION_NUMBER" ]; then
    echo "Bad Bash version: Required($UNITEX_TEST_MINIMAL_BASH_VERSION_STRING) - Using($bash_version_string)"
    exit $UNITEX_TEST_DEFAULT_ERROR_CODE
  fi
}
# =============================================================================
# setup_script_traps
setup_script_traps() {
  # Create an array list composed by all variables having the prefix
  # UNITEX_TEST_SIGNAL_
  SCRIPT_SIGNAL_LIST=$(set -o posix ; set         |\
                       grep "UNITEX_TEST_SIGNAL_" |\
                       cut -d= -f2)
  SCRIPT_SIGNAL_LIST=( $SCRIPT_SIGNAL_LIST )
  local script_signal
  for script_signal in "${SCRIPT_SIGNAL_LIST[@]}"
  do
    # shellcheck disable=SC2064
    trap "die_with_critical_error \"Caught signal\" \"A $script_signal signal was received at line \$LINENO\"" $script_signal
  done
}
# =============================================================================
# print usage options
usage() {
    echo "Usage:"
    echo "  $UNITEX_TEST_SCRIPT_NAME [OPTIONS] [DIRECTORY|ULP_FILE]"
    echo "Options:"
    echo "  -M n    : enable or disable memory error detection tests"
    echo "            default=$UNITEX_TEST_MEMORY_ERRORS"
    echo "  -R n    : enable or disable non-regression tests"
    echo "            default=$UNITEX_TEST_NON_REGRESSION"
    echo "  -s file : create a command line summary log"
    echo "  -c n    : use or not ANSI color codes"
    echo "            default=$UNITEX_TEST_USE_ANSI_COLORS"
    echo "  -p n    : print execution logs to stdout"
    echo "            0 print none"
    echo "            1 print if error"
    echo "            2 always print"
    echo "            default=$UNITEX_TEST_PRINT_EXECUTION_LOGS"
    echo "  -d n    : if /dest folder is available, diff original and result files"
    echo "            0 never diff"
    echo "            1 diff if RunLog exits with warning($UNITEX_TEST_RUNLOG_WARNING_CODE)"
    echo "            2 diff if RunLog exits with error($UNITEX_TEST_RUNLOG_COMPARE_ERROR_CODE)"
    echo "            default=$UNITEX_TEST_DIFF_OUTPUT_FILES"
    echo "  -w n    : width of the log message when executing commands"
    echo "            default=$UNITEX_TEST_EXECUTION_LOG_MESSAGE_WIDTH"
    echo "  -v n    : manually set the verbosity level 0...7"
    echo "            0 (%%) [debug]       debug message"
    echo "            1 (II) [info]rmation purely informational message"
    echo "            2 (!!) [notice]      normal but significant condition"
    echo "            3 (WW) [warning]     warning condition"
    echo "            4 (EE) [error]       error condition"
    echo "            5 (CC) [critical]    critical condition"
    echo "            6 (^^) [alert]       action must be taken immediately"
    echo "            7 (@@) [panic]       unusable condition"
    echo "            default=$UNITEX_TEST_VERBOSITY"
    echo "  -h      : display this help and exit"
    exit $UNITEX_TEST_DEFAULT_ERROR_CODE
}  # usage()
# =============================================================================
# Logger levels e.g. log_[level_name] "action" "details"
# =============================================================================
# 0. (%%) [debug]       debug message
# 1. (II) [info]rmation purely informational message
# 2. (!!) [notice]      normal but significant condition
# 3. (WW) [warning]     warning condition
# 4. (EE) [error]       error condition
# 5. (CC) [critical]    critical condition
# 6. (^^) [alert]       action must be taken immediately
# 7. (@@) [panic]       unusable condition
# 8                     not a logging message
# =============================================================================
UNITEX_TEST_LOG_LEVEL_ALIAS=("%%" "II" "!!" "WW" "EE" "CC" "^^" "@@" "")
UNITEX_TEST_LOG_LEVEL_NAME=("Debug" "Information" "Notice" "Warning" \
                             "Error" "Critical" "Alert"  "Panic" "")
# =============================================================================
# debug log
log_debug()    { log 0  "${UNITEX_TEST_LOG_LEVEL_ALIAS[0]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_WHITE";      }

# information log
log_info()     { log 1  "${UNITEX_TEST_LOG_LEVEL_ALIAS[1]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_BROWN";      }

# notice log
log_notice()   { log 2  "${UNITEX_TEST_LOG_LEVEL_ALIAS[2]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_LIGHTGREEN"; }

# warning log
log_warn()     { log 3  "${UNITEX_TEST_LOG_LEVEL_ALIAS[3]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_YELLOW";     }

# error log
log_error()    { log 4  "${UNITEX_TEST_LOG_LEVEL_ALIAS[4]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_RED";        }

# critical log
log_critical() { log 5  "${UNITEX_TEST_LOG_LEVEL_ALIAS[5]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_LIGHTRED";   }

# alert log
log_alert()    { log 6  "${UNITEX_TEST_LOG_LEVEL_ALIAS[6]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_LIGHTRED";   }

# panic log
log_panic()    { log 7  "${UNITEX_TEST_LOG_LEVEL_ALIAS[7]}" "$1" "$2" "$3" "$UNITEX_TEST_CONSOLE_COLOR_LIGHTRED";   }

# none log
log_none()     { log 8  "${UNITEX_TEST_LOG_LEVEL_ALIAS[8]}" "$1"  ""  "";                                      }
# =============================================================================
# UNITEX_TEST_LOG_FORMAT
# printf formatted string
# 1 : log message level : !!, II, WW, EE, ??                       -b1-4
# 2 : stage name : User Manual, Core Components, IDE Java ...      -b6-20
# 3 : action                                                       -b23-43
# 4 : description                                                  -b44-
#                            1       2      3     4
UNITEX_TEST_LOG_FORMAT_COLOR="%b(%.2s)%b %b[%-4s]%b  %-20s : %s\n"
UNITEX_TEST_LOG_FORMAT_NO_COLOR="(%.2s) [%-4s]  %-20s : %s\n"
#                             1    4 6    20  23  44
# =============================================================================
# Push directory with logging check
push_directory() {
 if [ -d "$1" ]; then
  pushd "$1" > /dev/null
 else
  log_warn "Directory not found" "directory $1 doesn't exist"
 fi
}  # push_directory()
# =============================================================================
# Pop directory without error message
pop_directory() {
 popd > /dev/null
} # pop_directory
# =============================================================================
# Notify fails by verbosity level
notify_fail_log_level_count() {
  for i in "${!UNITEX_TEST_LOG_LEVEL_COUNTER[@]}"; do
    # shellcheck disable=SC2086
    if [ $UNITEX_TEST_VERBOSITY -eq 0 -a $i -le 7 ]; then
      log_debug "${UNITEX_TEST_LOG_LEVEL_NAME[$i]} messages" \
                "${UNITEX_TEST_LOG_LEVEL_COUNTER[$i]}"
    elif [ $i -ge 3  -a $i -le 7 ]; then
      if [ ${UNITEX_TEST_LOG_LEVEL_COUNTER[$i]} -ge 1 ]; then
        log_info "${UNITEX_TEST_LOG_LEVEL_NAME[$i]} messages" \
                 "${UNITEX_TEST_LOG_LEVEL_COUNTER[$i]}"
      fi
    fi
  done
}
# =============================================================================
# Notify fails execution count
notify_fail_command_execution_count() {
  if [ $UNITEX_TEST_COMMAND_EXECUTION_ERROR_COUNT -ge 1 ]; then
    log_info  "Command execution" \
    "$UNITEX_TEST_COMMAND_EXECUTION_ERROR_COUNT/$UNITEX_TEST_COMMAND_EXECUTION_COUNT fails"
  fi
}
# =============================================================================
notify_elapsed_time() {
  TIMESTAMP_FINISH_A=$(date +'%F %T %z')
  END_SECONDS=$(date +%s)
  DIFF_SECONDS=$(( END_SECONDS - START_SECONDS ))
  TOTAL_ELAPSED_TIME=$(echo -n $DIFF_SECONDS | gawk '{print strftime("%H:%M:%S", $1,1)}')

  # notify that the work was done
  log_info "Overall elapsed time" "$TOTAL_ELAPSED_TIME"
}
# =============================================================================
count_issues_until_now() {
  local __issues_variable=${1:?Output variable name required}
  local issues_count=$UNITEX_TEST_COMMAND_EXECUTION_ERROR_COUNT

  # check if script is complete with no errors
  # 3=Message Error and 7=Message Panic
  for i in "${!UNITEX_TEST_LOG_LEVEL_COUNTER[@]}"; do
    # shellcheck disable=SC2086
    if [ $i -ge 3 -a $i -le 7 ]; then
      # shellcheck disable=SC2086
      if [ ${UNITEX_TEST_LOG_LEVEL_COUNTER[$i]} -ge 1 ]; then
        issues_count=$(( issues_count + UNITEX_TEST_LOG_LEVEL_COUNTER[i] ))
      fi
    fi
  done

  # shellcheck disable=SC2140
  eval "$__issues_variable"="'$issues_count'"
}  # count_issues_until_now
# =============================================================================
notify_finish() {
  # notify number of messages for each log level >= warning
  notify_fail_log_level_count

  # notify number of fail executions
  notify_fail_command_execution_count

  # notify elapsed time
  notify_elapsed_time

  # count errors until now
  count_issues_until_now UNITEX_TEST_FINISH_WITH_ERROR_COUNT

  # Remove files (e.g *$UNITEX_TEST_UNTRACED.log) with zero size from the logger workspace
  # test first if logger workspace path exists
  if [ -d "$UNITEX_TEST_LOG_WORKSPACE" ]; then
    push_directory "$UNITEX_TEST_LOG_WORKSPACE"
    {
      find "$UNITEX_TEST_LOG_WORKSPACE" -size 0 | \
           while read f; do rm -f "$f" ; done
    } & wait
    pop_directory
  fi

  # final message
  if [ $UNITEX_TEST_FINISH_WITH_ERROR_COUNT -eq 0 ]; then
    log_notice "Happy ending"   "$TIMESTAMP_FINISH_A"
  else
    log_info "Unhappy ending" "$TIMESTAMP_FINISH_A"
  fi
}
# =============================================================================
clean_exit() {
  # reset traps
  # shellcheck disable=SC2046
  trap - $(printf "%s "  "${SCRIPT_SIGNAL_LIST[@]}")

  # notify that the process is finished
  notify_finish

  # restore streams
  pop_streams

  # exit
  exit $UNITEX_TEST_FINISH_WITH_ERROR_COUNT
}
# =============================================================================
# exit with critical error
die_with_critical_error() {
  # print message
  log_critical "$@"

  # exit with error
  clean_exit
}  # die_with_critical_error
# =============================================================================
# main logging function
# avoid call this function directly, use instead :
# log_[level] "message" "description"
# 1:LEVEL, 2:ALIAS, 3:MESSAGE, 4:DESCRIPTION; 5: TEST STATUS; 6: COLOR
log() {
  if [ "$1" -ge $UNITEX_TEST_VERBOSITY -a "$1" -le 7 ]; then
    {
      # Increment log level counter
      (( UNITEX_TEST_LOG_LEVEL_COUNTER[$1]++ ))

      # Increment the number of logged messages
      (( UNITEX_TEST_LOG_MESSAGE_COUNT++ ))

      # if test status is empty print the number of the message
      if [ ${#5} -eq 0 -a "$3" == "Executing" ]; then
        UNITEX_TEST_STATUS=$($UNITEX_TEST_TOOL_PRINTF "%0.4d" "$UNITEX_TEST_LOG_MESSAGE_COUNT")
      else
        UNITEX_TEST_STATUS="$5"
      fi

      if [ $UNITEX_TEST_USE_ANSI_COLORS -eq 1 ]; then
        # shellcheck disable=SC2059
        $UNITEX_TEST_TOOL_PRINTF "$UNITEX_TEST_LOG_FORMAT_COLOR" "$6" "$2" "$UNITEX_TEST_CONSOLE_RESET" "$6" "$UNITEX_TEST_STATUS" "$UNITEX_TEST_CONSOLE_RESET" "$3" "$4"
      else
        $UNITEX_TEST_TOOL_PRINTF "$UNITEX_TEST_LOG_FORMAT_NO_COLOR" "$2" "$UNITEX_TEST_STATUS" "$3" "$4"
      fi
    } >&3
  # log_none messages are not formatted, we send them directly to the STDOUT!
  elif [ "$1" -eq 8 ]; then
    echo "$3" >&3
  fi
}
# =============================================================================
# Create a temporary directory in $2 (or /tmp) prefixed by 'uct'
# and concatenate to a random sequence
create_temporal_directory() {
  local  __output_variable=$1
  local  __tmpdir="/tmp"

  # setup __tmpdir_argument
  if [ $# -ge 2 ]; then
     if [ -d "$2" ]; then
        local  __tmpdir="$2"
     else
        log_warn "Directory not found" "directory $2 doesn't exist"
    fi
  fi

  local  my_temporal_directory
  my_temporal_directory=$(mktemp -d --tmpdir="$__tmpdir"  "uct"XXXXX 2>/dev/null) || {
    # workaround for OS X @see http://unix.stackexchange.com/a/84980
    my_temporal_directory=$(mktemp -d -t 'uct') || {
      die_with_critical_error "Build error" "Failed to create a temporal directory in $my_temporal_directory";
    }
  }

  # normalize path
  my_temporal_directory="$(readlinkf "$my_temporal_directory")"

  # shellcheck disable=SC2140
  eval "$__output_variable"="'$my_temporal_directory'"
}  # create_temporal_directory
# =============================================================================
# process command line
process_command_line() {
  # parse command line
  while getopts "M:R:s:c:p:d:w:v:h?" opt; do
      case "$opt" in
        M)  case $OPTARG in
               (*[!0-1]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -M bad value. Valid values are [0-1]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_MEMORY_ERRORS=$OPTARG
            ;;
        R)  case $OPTARG in
               (*[!0-1]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -R bad value. Valid values are [0-1]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_NON_REGRESSION=$OPTARG
            ;;
        s)  if [[ (-f "$OPTARG" && -w "$OPTARG") || ! -e "$OPTARG" ]]; then
             touch "$OPTARG" > /dev/null 2>&1 || {
              echo "cannot create '$OPTARG': No such file or directory"
              exit $UNITEX_TEST_DEFAULT_ERROR_CODE
             }
            else
              echo "./$UNITEX_TEST_SCRIPT_NAME: -l bad value. Expecting a writable file"
              exit $UNITEX_TEST_DEFAULT_ERROR_CODE
            fi
            UNITEX_TEST_COMMAND_LINE_LOG_FILE="$OPTARG"
            ;;
        c)  case $OPTARG in
               (*[!0-1]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -c bad value. Valid values are [0-1]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_USE_ANSI_COLORS=$OPTARG
            if [ "$UNITEX_TEST_USE_ANSI_COLORS" -eq 0 ]; then
              UNITEX_TEST_DIFF_COLORS="--no-color"
            fi
            ;;
        p)  case $OPTARG in
               (*[!0-2]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -p bad value. Valid values are [0...2]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_PRINT_EXECUTION_LOGS=$OPTARG
            ;;
        d)  case $OPTARG in
               (*[!0-2]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -d bad value. Valid values are [0...2]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_DIFF_OUTPUT_FILES=$OPTARG
            ;;
        w)  if [[ $OPTARG =~ ^[0-9]+$ ]] && (( OPTARG > 0)); then
              UNITEX_TEST_EXECUTION_LOG_MESSAGE_WIDTH=$OPTARG
            else
              echo "./$UNITEX_TEST_SCRIPT_NAME: -w bad value. Valid values are n > 0"
            fi
            ;;
        v)  case $OPTARG in
               (*[!0-7]*|'') echo "./$UNITEX_TEST_SCRIPT_NAME: -v bad value. Valid values are [0...7]"
               exit $UNITEX_TEST_DEFAULT_ERROR_CODE
               ;;
            esac
            UNITEX_TEST_VERBOSITY=$OPTARG
            ;;
        h|\?)
            usage
            ;;
      esac
  done

  shift $((OPTIND-1))

  [ "$1" = "--" ] && shift

  # the last argument would be a directory, a .ulp file or nothing
  if [ $# -gt 1 ]; then
    echo "./$UNITEX_TEST_SCRIPT_NAME: too many arguments"
    usage
  fi

  # if exists, the last argument is a directory or a .ulp file
  if [ $# -eq 1 ]; then
    UNITEX_TEST_TARGET="$(readlinkf "$1")"
  fi

  if   [ -d "$UNITEX_TEST_TARGET" ]; then
    UNITEX_TEST_FILES="$(find -L   "$UNITEX_TEST_TARGET"                           \
                        -not -name ".*"                                            \
                        -not -name "*.rerun.ulp"                                   \
                             -name "*$UNITEX_TEST_ULP_EXTENSION"                   \
                             -type f -print                                       |\
                         sort)"
  elif [ -f "$UNITEX_TEST_TARGET" ]; then
    case "$UNITEX_TEST_TARGET" in
      *$UNITEX_TEST_ULP_EXTENSION) UNITEX_TEST_FILES="$UNITEX_TEST_TARGET" ;;
      *)                           echo "Only $UNITEX_TEST_ULP_EXTENSION files are supported" &&\
                                   exit $UNITEX_TEST_DEFAULT_ERROR_CODE    ;;
    esac
  else
    echo "./$UNITEX_TEST_SCRIPT_NAME: bad argument: \"$1\""
    usage
  fi

  # count the number of characters on UNITEX_TEST_FILES
  UNITEX_TEST_FILES_SIZE=${#UNITEX_TEST_FILES}
  # check if there are tests to perform
  if [ "$UNITEX_TEST_FILES_SIZE" -eq 0 ]; then
    echo "Directory $UNITEX_TEST_TARGET doesn't contain any supported file (with $UNITEX_TEST_ULP_EXTENSION extension)"
    exit $UNITEX_TEST_DEFAULT_ERROR_CODE
  fi

  # UNITEX_BIN environment variable could overwrite UNITEX_TEST_TOOL_BIN
  if [ -n "${UNITEX_BIN+1}" ]; then
     # use the environment config
     UNITEX_TEST_TOOL_BIN="$UNITEX_BIN"
  fi

  # if UnitexToolLogger doesn't exist
  if [ ! -e "$UNITEX_TEST_TOOL_BIN" ]; then
    echo "$(basename "$UNITEX_TEST_TOOL_BIN") not found"
    echo "try e.g. export UNITEX_BIN=/foo/bar/App/$(basename "$UNITEX_TEST_TOOL_BIN")"
    exit $UNITEX_TEST_DEFAULT_ERROR_CODE
  fi

  # UNITEX_TEST_TOOL_BIN
  UNITEX_TEST_TOOL_BIN="$(readlinkf "$UNITEX_TEST_TOOL_BIN")"

  if [ "$UNITEX_TEST_MEMORY_ERRORS" -eq 1 ]; then
    command -v "${UNITEX_TEST_TOOL_VALGRIND}" > /dev/null ||\
    {
      echo "./$UNITEX_TEST_SCRIPT_NAME: $UNITEX_TEST_TOOL_VALGRIND not found"
      echo "  On OS-X, use brew install --HEAD valgrind"
      echo "  On Debian/Ubuntu, use apt-get install valgrind"
      echo "  On Fedora/RHEL, use yum install valgrind"
      echo "  To install Valgrind from sources check http://goo.gl/1Ccqxy"
      exit $UNITEX_TEST_DEFAULT_ERROR_CODE
    }
  fi
}  # function process_command_line()
# =============================================================================
# temporally save std output/error
push_streams() {
  # Save standard output(1->3) and standard error(2->4)
  exec 3>&1 4>&2
}  # function push_streams()
# =============================================================================
# Restore original outputs and close unused descriptors
pop_streams() {
  # Restore original stdout/stderr
  exec 1>&3 2>&4
  # Close the unused descriptors
  exec 3>&- 4>&-
}
# =============================================================================
# Redirect standart output to a file
# Never call logger functions or die_with_critical_error from here
redirect_stdout() {
  REDIRECT_TO_PARTIALNAME="$UNITEX_TEST_LOG_WORKSPACE/$1"

  if [ "$UNITEX_TEST_CURRENT_STDOUT" != \
       "$REDIRECT_TO_PARTIALNAME$UNITEX_TEST_LOG_FILE_EXT" ];then
    if [ -e "$REDIRECT_TO_PARTIALNAME$UNITEX_TEST_LOG_FILE_EXT" -a \
         -s "$REDIRECT_TO_PARTIALNAME$UNITEX_TEST_LOG_FILE_EXT" ] ; then
        FILENAME_SUFFIX_COUNTER=1
        while [[ -e $REDIRECT_TO_PARTIALNAME.$FILENAME_SUFFIX_COUNTER$UNITEX_TEST_LOG_FILE_EXT ]] ; do
            let FILENAME_SUFFIX_COUNTER++
        done
        REDIRECT_TO_PARTIALNAME=$REDIRECT_TO_PARTIALNAME.$FILENAME_SUFFIX_COUNTER
    fi

    # shellcheck disable=SC2034
    UNITEX_TEST_PREVIOUS_STDOUT="$UNITEX_TEST_CURRENT_STDOUT"
    UNITEX_TEST_CURRENT_STDOUT="$REDIRECT_TO_PARTIALNAME$UNITEX_TEST_LOG_FILE_EXT"
    # Redirect standard output to a log file
    exec 1> "$UNITEX_TEST_CURRENT_STDOUT"
  fi
}
# =============================================================================
# Redirect standart output and error to a file
redirect_std() {
  redirect_to_filename="$1"
  # Redirect standard output to a log file
  redirect_stdout "$redirect_to_filename"

  # Redirect standart error to the same log file
  exec 2>&1

  # Silent when NO_LOG_DEBUG is passed
  if [ $# -eq 1 ]; then
    log_debug "Streaming into" "$UNITEX_TEST_CURRENT_STDOUT"
  fi
}
# =============================================================================
# exec_logged_command "command_name" "command_args"
exec_logged_command() {
  # binary command name
  command_name="$1"
  shift

  # all the rest are parameters
  command_args="$*"

  # pretty_command_args
  # 1. anonymize passwords      (--password *****) and users (--username *****)
  # 2. anonymize mail addresses (foo-at-bar.com => foo-at-b**.com)
  # 3. anonymize paths          (foo/bar        => bar)
  pretty_command_args=$(echo "$command_args" |\
  sed 's%\(user\(name\)\?\|pass\(word\)\?\)\( \)\+\([^ ]\+\)%\1 ********%g' |\
  sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta' |\
  sed -e "s|$UNITEX_TEST_SCRIPT_BASEDIR/||g" )

  # test if command_name isn't empty
  if [ ! "$command_name" ]; then
     die_with_critical_error "Aborting" "Trying to execute empty command"
  fi

  # test if command exists
  command -v "$command_name" > /dev/null || \
  {
    die_with_critical_error "Aborting" "$command_name is required but it's not installed"
  }

  # redirect stdout and stderr to logfile
  # starting 1.4.0 redirect_std_name is defined here as
  redirect_std_name=$(printf "%0.3d_%s"                       \
                      "$((UNITEX_TEST_LOG_MESSAGE_COUNT+1))" \
                      "$(basename "$command_name")")
  # do not to use especial characters on the file name
  redirect_std_name="$($UNITEX_TEST_TOOL_PRINTF  "${redirect_std_name,,}" | sed -e 's/[^a-z0-9_-]/_/g')"
  redirect_std "$redirect_std_name"

  # create command line array
  command_line=( $command_name "$command_args" )

  pretty_command_name=$(basename "$command_name")
  pretty_command_line=$($UNITEX_TEST_TOOL_PRINTF "$pretty_command_name $pretty_command_args" | \
                        cut -c 1-"$UNITEX_TEST_EXECUTION_LOG_MESSAGE_WIDTH")

  if [[ ${#pretty_command_line} -ge $UNITEX_TEST_EXECUTION_LOG_MESSAGE_WIDTH ]]; then
    pretty_command_line="$pretty_command_line..."
  fi

  COMMAND_START_SECONDS=$(date +%s)
  COMMAND_TIMESTAMP_START_C="$(date +'%F %T %z')"

  # command logging header
  echo "# Command Logging $COMMAND_TIMESTAMP_START_C"
  # shellcheck disable=SC2001
  echo "# $(echo "$UNITEX_TEST_CURRENT_STDOUT" | sed "s|$UNITEX_TEST_SCRIPT_BASEDIR/\?||g")"
  echo "# $pretty_command_name $pretty_command_args"

  # logging information
  log_notice "Executing" "$pretty_command_line"

  {
    # execute command
    eval "${command_line[@]}"

    # save return code
    exit_status=$?
  }

  # elapsed time
  COMMAND_END_SECONDS=$(date +%s)
  COMMAND_DIFF_SECONDS=$(( COMMAND_END_SECONDS - COMMAND_START_SECONDS ))
  COMMAND_ELAPSED_TIME=$($UNITEX_TEST_TOOL_PRINTF $COMMAND_DIFF_SECONDS | gawk '{print strftime("%H:%M:%S", $1,1)}')

  # Increment command execution counter
  (( UNITEX_TEST_COMMAND_EXECUTION_COUNT++ ))

  # test return code
  if [ $exit_status -ne 0 ]; then
    log_debug "Error executing" "$pretty_command_line"
    echo      "# Finished with errors"
    echo      "# Return status : $exit_status"
    # Increment fail execution counter
    (( UNITEX_TEST_COMMAND_EXECUTION_ERROR_COUNT++ ))
  else
    echo      "# Successfully finished"
  fi

  # command logging footer
  echo "# Elapsed time  : $COMMAND_ELAPSED_TIME"

  # restore stdout and stderr
  if [ ! -z "$UNITEX_TEST_CURRENT_STAGE" ]; then
    # All untraced execution commands, i.e. not running thorough
    # exec_logged_command call, will be kept in an .untraced.log file
    redirect_std_name=$(printf "%s_%0.3d_%s"                    \
                      "untraced"                                \
                      "$((UNITEX_TEST_LOG_MESSAGE_COUNT + 1))"  \
                      "$command_name")
    redirect_std_name="$($UNITEX_TEST_TOOL_PRINTF  "${redirect_std_name,,}" | sed -e 's/[^a-z0-9_-]/_/g')"
    redirect_std "$redirect_std_name" NO_LOG_DEBUG
  fi

  # print the logged command execution if -p1 and errors or -p2
  if [[ ($exit_status -ne 0 && $UNITEX_TEST_PRINT_EXECUTION_LOGS -ge 1) ||\
        ($exit_status -eq 0 && $UNITEX_TEST_PRINT_EXECUTION_LOGS -ge 2) ]]; then
    cat "$UNITEX_TEST_CURRENT_STDOUT" >&3
  fi

  # return the status
  return $exit_status
}
# =============================================================================
unitex_tests_run() {
  UNITEX_TEST_HAS_ERRORS=0
  UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME="$UNITEX_TEST_LOG_WORKSPACE/execution_summary$UNITEX_TEST_LOG_FILE_EXT"
  UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FILENAME=$(basename "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME")
  UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME="$UNITEX_TEST_LOG_WORKSPACE/error_summary$UNITEX_TEST_LOG_FILE_EXT"
  UNITEXTOOLLOGGER_ERROR_SUMMARY_FILENAME=$(basename "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME")

  # command-line summary
  if [ -n "${UNITEX_TEST_COMMAND_LINE_LOG_FILE}" ]; then
    while read -r i ; do
      log_debug "Reading command line" "Reading ${i//$UNITEX_TEST_SCRIPT_BASEDIR\//}"
      {
       echo  -e "# ${i//$UNITEX_TEST_SCRIPT_BASEDIR\//}"
       unzip -p "$i" "test_info/command_line_synth.txt"
       echo  -e "\n"
      } >> "$UNITEX_TEST_COMMAND_LINE_LOG_FILE" 2>>"$UNITEX_TEST_COMMAND_LINE_LOG_FILE"
    done < <(echo "$UNITEX_TEST_FILES")
  fi  # if [ -n "${UNITEX_TEST_COMMAND_LINE_LOG_FILE}" ]; then

  # non-regression tests
  if [ "$UNITEX_TEST_NON_REGRESSION" -eq 1 ]; then
    log_info "Running logs" "Preparing to replay all ULPs files"
    while read -r i ; do
      log_debug "Running" "$i"
      UNITEX_TEST_CURRENT_TEST_NAME=$(basename "$i")
      # .log/foo.orig
      UNITEX_TEST_ORIG_ULP_DIR="$UNITEX_TEST_LOG_WORKSPACE/${UNITEX_TEST_CURRENT_TEST_NAME%$UNITEX_TEST_ULP_EXTENSION}.orig"
      # setup -r parameter to save the resulting ulp
      UNITEX_TEST_RESULT_ULP_PARAM=""
      # .log/foo.result
      UNITEX_TEST_RESULT_ULP_DIR="$UNITEX_TEST_LOG_WORKSPACE/${UNITEX_TEST_CURRENT_TEST_NAME%$UNITEX_TEST_ULP_EXTENSION}.result"
      UNITEX_TEST_RESULT_ULP_NAME="$UNITEX_TEST_RESULT_ULP_DIR$UNITEX_TEST_ULP_EXTENSION"
      if [ "$UNITEX_TEST_DIFF_OUTPUT_FILES" -ge 1 ]; then
        UNITEX_TEST_RESULT_ULP_PARAM="-r $UNITEX_TEST_RESULT_ULP_NAME"
      else
        UNITEX_TEST_RESULT_ULP_PARAM="--cleanlog"
      fi

      RUNLOG_EXECUTION_FAIL=0
      RUNLOG_EXIT_STATUS=0
      exec_logged_command "$UNITEX_TEST_TOOL_BIN"                             \
                          RunLog "\"$i\""                                     \
                          -s "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME"   \
                          -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"  \
                          -d tempdir                                          \
                          --clean "$UNITEX_TEST_RESULT_ULP_PARAM"             \
                          || {
                            # save return code
                            RUNLOG_EXIT_STATUS=$?
                            RUNLOG_EXECUTION_FAIL=1
                          }
      if [ $RUNLOG_EXECUTION_FAIL -ne 0 ]; then
        # RunLog warning return code is equal to 79
        if   [  $RUNLOG_EXIT_STATUS -eq $UNITEX_TEST_RUNLOG_WARNING_CODE ]; then
          log_warn  "Warning detected" "RunLog detected a warning while replaying $UNITEX_TEST_CURRENT_TEST_NAME" "WARN"
        # RunLog error return code is equal to 80
        elif [  $RUNLOG_EXIT_STATUS -eq $UNITEX_TEST_RUNLOG_COMPARE_ERROR_CODE ]; then
          log_error "Regression detected" "RunLog detected a regression while replaying $UNITEX_TEST_CURRENT_TEST_NAME" "FAIL"
          UNITEX_TEST_HAS_ERRORS=1
        else
          log_error "Error detected" "RunLog detected an error while replaying $UNITEX_TEST_CURRENT_TEST_NAME" "FAIL"
          UNITEX_TEST_HAS_ERRORS=1
        fi

        # diff resulting files when required
        if [[ ( ( $UNITEX_TEST_DIFF_OUTPUT_FILES -ge 1 ) && ( $RUNLOG_EXIT_STATUS -ge $UNITEX_TEST_RUNLOG_WARNING_CODE ) )       ||\
              ( ( $UNITEX_TEST_DIFF_OUTPUT_FILES -ge 2 ) && ( $RUNLOG_EXIT_STATUS -eq $UNITEX_TEST_RUNLOG_COMPARE_ERROR_CODE ) ) ]]; then
          # only if the input log has a dest/ folder
          unzip -q "$i"                           "dest/*" -d "$UNITEX_TEST_ORIG_ULP_DIR"      > /dev/null 2>&1 && {
            # list the original files to compare
            UNITEX_TEXT_ORIG_FILES="$(find -L   "$UNITEX_TEST_ORIG_ULP_DIR"      \
                                      -not -name ".*"                            \
                                      -not -name "*.ulp"                         \
                                           -name "*"                             \
                                           -type f -print)"
            # decompress the result files
            unzip -q "$UNITEX_TEST_RESULT_ULP_NAME" "dest/*" -d "$UNITEX_TEST_RESULT_ULP_DIR"  > /dev/null 2>&1
            # compare original vs result files
            while read -r filename ; do
              UNITEX_TEST_ULP_ORIG_FILE="$filename"
              UNITEX_TEST_ULP_RESULT_FILE="${filename/.orig/.result}"
              # try to convert from utf16-le-bom to utf8-no-bom
              $UNITEX_BIN Convert -sutf16-le-bom -dutf8-no-bom "$UNITEX_TEST_ULP_ORIG_FILE"    > /dev/null 3>&4
              $UNITEX_BIN Convert -sutf16-le-bom -dutf8-no-bom "$UNITEX_TEST_ULP_RESULT_FILE"  > /dev/null 3>&4
              # compare using git diff
              GIT_DIFF_EXIT_STATUS=0
              exec_logged_command git --no-pager diff "\"$UNITEX_TEST_DIFF_COLORS\"" \
                                      --no-index                                     \
                                      --binary                                       \
                                      --unified=0                                    \
                                      -w                                             \
                                      "\"$UNITEX_TEST_ULP_ORIG_FILE\""               \
                                      "\"$UNITEX_TEST_ULP_RESULT_FILE\"" || {
                                        # save return code
                                        GIT_DIFF_EXIT_STATUS=$?
                                      }
              if [ $GIT_DIFF_EXIT_STATUS -ne 0 ]; then
                log_error   "Differences found"  "$(basename "$UNITEX_TEST_ULP_ORIG_FILE")" "FAIL"
              else
                log_notice  "No differences" "$(basename "$UNITEX_TEST_ULP_ORIG_FILE")" "PASS"
              fi
            done < <(echo "$UNITEX_TEXT_ORIG_FILES")
          }
        fi
      else
        log_notice  "Successful execution" "RunLog does not detect any regression while replaying $UNITEX_TEST_CURRENT_TEST_NAME" "PASS"
      fi

      if [ -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" ]; then
        UNITEX_TEST_HAS_ERRORS=1
        cat   "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" >> "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME"
        rm -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"
      fi

      # remove resulting ulp file
      rm -f "${UNITEX_TEST_RESULT_ULP_NAME:?}"
    done < <(echo "$UNITEX_TEST_FILES")
  fi  # if [ "$UNITEX_TEST_NON_REGRESSION" -eq 1 ]; then

  # memcheck + non-regression tests
  if [ $UNITEX_TEST_HAS_ERRORS      -eq 0 -a \
       "$UNITEX_TEST_MEMORY_ERRORS" -eq 1 ]; then
    log_info "Running Valgrind" "Preparing to replay all ULPs files using Valgrind"
    while read -r i ; do
      log_debug "Running valgrind" "$i"
      UNITEX_TEST_CURRENT_TEST_NAME=$(basename "$i")

      VALGRIND_LOG_NAME=$(basename "$i" | sed -e 's/[^A-Za-z0-9_-]/_/g')
      VALGRIND_LOG_FULLNAME="$UNITEX_TEST_LOG_WORKSPACE/valgrind.$VALGRIND_LOG_NAME$UNITEX_TEST_LOG_FILE_EXT"
      VALGRIND_EXECUTION_FAIL=0
      # save valgrind return code
      VALGRIND_EXIT_STATUS=0
      exec_logged_command "$UNITEX_TEST_TOOL_VALGRIND"                         \
                          --tool=memcheck                                      \
                          --error-exitcode=$UNITEX_TEST_MEMORY_ERROR_CODE      \
                          --leak-check=full                                    \
                          --vex-iropt-level=1                                  \
                          --show-reachable=yes                                 \
                          --track-origins=yes                                  \
                          "$UNITEX_TEST_TOOL_BIN"                              \
                          RunLog "\"$i\""                                      \
                          -s "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME"    \
                          -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"   \
                          -d tempdir                                           \
                          --clean                                              \
                          --cleanlog || {
                            VALGRIND_EXIT_STATUS=$?
                            VALGRIND_EXECUTION_FAIL=1
                          }

      if [ $VALGRIND_EXECUTION_FAIL -ne 0 ]; then
        # Valgrind memcheck return code is equal to 66
        if [  $VALGRIND_EXIT_STATUS -eq $UNITEX_TEST_MEMORY_ERROR_CODE ]; then
          log_error "Memory error" "Valgrind detect a memory error when replaying $UNITEX_TEST_CURRENT_TEST_NAME" "FAIL"
        else
          log_error "Regression detected" "RunLog detected a regression while replaying $UNITEX_TEST_CURRENT_TEST_NAME with Valgrind" "FAIL"
        fi
        UNITEX_TEST_HAS_ERRORS=1
      else
        log_notice  "Successful execution" "Valgrind does not detect any memory errors replaying $UNITEX_TEST_CURRENT_TEST_NAME" "PASS"
        rm -f "$VALGRIND_LOG_FULLNAME"
      fi

      if [ -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" ]; then
        log_warn  "Regression detected" "RunLog under Valgrind detected a regression while replaying $UNITEX_TEST_CURRENT_TEST_NAME" "FAIL"
        UNITEX_TEST_HAS_ERRORS=1
        cat   "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" >> "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME"
        rm -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"
      else
        log_debug  "Successful execution"  "RunLog under Valgrind does not detect any regression while replaying $UNITEX_TEST_CURRENT_TEST_NAME"
      fi
    done < <(echo "$UNITEX_TEST_FILES")  # for i in "$UNITEX_TEST_TARGET"

    if [ -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME" -a \
         -s "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME" ]; then
      log_warn "Regressions detected" \
               "Some regression tests did not complete successfully, see $UNITEX_TEST_LOG_RELATIVE_WORKSPACE/$UNITEXTOOLLOGGER_ERROR_SUMMARY_FILENAME for more details"
    else
      log_info "No regression" \
               "All logs were successfully replayed, see $UNITEX_TEST_LOG_RELATIVE_WORKSPACE/$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FILENAME for more details"
    fi
  fi  # $UNITEX_TEST_HAS_ERRORS -eq 0 "$UNITEX_TEST_MEMORY_ERRORS" -eq 1


}  # function stage_unitex_core_logs_run()
# =============================================================================
# print log header
print_log_header() {
  {
    echo -e "\r# $UNITEX_TEST_CODENAME / $TIMESTAMP_START_C\n"                 \
            "\r# Markers:\n"                                                   \
            "\r# (%%) debug, (II) information, (!!) notice,   (WW) warning,\n" \
            "\r# (EE) error, (CC) critical,    (^^) alert,    (@@) panic"
  } >&3
  if [ -n "${UNITEX_CORE_VERSION_GIT_COMMIT_HASH+1}" ]; then
     log_info "Unitex Core" "$UNITEX_CORE_REPOSITORY/commit/$UNITEX_CORE_VERSION_GIT_COMMIT_HASH"
  else
   log_info "Unitex Core" "$($UNITEX_BIN VersionInfo -s)"
  fi
  log_info "Unitex Core Tests"   "$UNITEX_TEST_REPOSITORY/commit/$(git describe --always HEAD)"

  log_info "Workspace" "The log workspace is located at $UNITEX_TEST_LOG_RELATIVE_WORKSPACE"

  if [ -n "${UNITEX_TEST_COMMAND_LINE_LOG_FILE}" ]; then
    {
      echo -e "# $UNITEX_TEST_CODENAME / Commmand Line Summary / $TIMESTAMP_START_C\n"
      log_info "Command Line Summary" "Command line summary saved in $UNITEX_TEST_COMMAND_LINE_LOG_FILE"
    } > "$UNITEX_TEST_COMMAND_LINE_LOG_FILE"
  fi
}
# =============================================================================
# create a temporal workspace
create_temporal_workspace() {
  mkdir -p "$UNITEX_TEST_SCRIPT_BASEDIR/$UNITEX_TEST_LOG_FILE_EXT"
  create_temporal_directory UNITEX_TEST_LOG_WORKSPACE "$UNITEX_TEST_SCRIPT_BASEDIR/$UNITEX_TEST_LOG_FILE_EXT"
  if [ ! -d "$UNITEX_TEST_LOG_WORKSPACE" ]; then
    die_with_critical_error "Unrecoverable error" "Error creating temporal workspace directory"
  fi
  UNITEX_TEST_LOG_RELATIVE_WORKSPACE=$($UNITEX_TEST_TOOL_PRINTF "$UNITEX_TEST_LOG_WORKSPACE" |\
                                       sed -e "s|$UNITEX_TEST_SCRIPT_BASEDIR/||g" )
}
# =============================================================================
# main
# =============================================================================
# process command line arguments in $@
process_command_line "$@"

# check minimal allowed bash version
check_bash_version

# push streams
push_streams

# install interrupt (INT) and terminate (TERM) traps
setup_script_traps

# create a temporal workspace
create_temporal_workspace

# print log header
print_log_header

# run tests
unitex_tests_run

# clean exit
clean_exit
