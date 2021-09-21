# Unitex/GramLab Core Integration Tests [![Build Status](https://api.travis-ci.com/UnitexGramLab/unitex-core-tests.svg?branch=master)](https://app.travis-ci.com/UnitexGramLab/unitex-core-tests)

> [Unitex/GramLab][unitex] is an open source, cross-platform, multilingual, lexicon- and grammar-based corpus processing suite

This repository contains the [Unitex Core][unitex-core] non-regression and memory error 
detection tests which are run after a commit or before release a nightly build. These tests 
should be also run by the contributors before send a pull-request.

<p align="center">
  <img src="http://www-igm.univ-mlv.fr/~unitex/img/unitex-core-test.png" width="50%" height="50%" alt="Unitex Core Tests"/>
</p>

## Dependencies

1. Make sure you have already a `UnitexToolLogger` binary built including debug 
   symbols with no optimization,  if not follow the instructions on the [Unitex Core][unitex-core]
   to compile it

1. To run a single `ulp` test, you don't need to use the `unitex-core-test.sh`
   script, you can simple type on the command line, e.g.

   ```
   UnitexToolLogger RunLog Compress/Compress_bin2.ulp
   ```

   However, if you are planning to run multiple tests on a regular basis,
   including memory error detection tests, the recommended approach is to
   continue reading and use `unitex-core-test.sh`

1. `Bash` v4.2.0 is the minimum version required to run `unitex-core-test.sh`.
    Type `bash --version` to check your installed version. To upgrade Bash:
    
  - On OS-X, use `brew update` and the `brew install bash`
  - On Debian/Ubuntu, use `apt-get update` and then `apt-get install --only-upgrade bash`
  - On Fedora/RHEL, use `yum -y install bash`
  - On Windows, see the `MSYS2` package available [here](https://sourceforge.net/projects/msys2)

   If you are not running as root, prepend `sudo` to each command
   
1. To detect memory errors, you will need the [Valgrind](http://valgrind.org) suite of tools installed on your system:

  - On OS-X, use `brew install --HEAD valgrind`
  - On Debian/Ubuntu, use `apt-get install valgrind`
  - On Fedora/RHEL, use `yum install valgrind`
  - To install `valgrind` from sources check [here](http://valgrind.org/docs/manual/dist.install.html)
  - Currently, there is not a `valgrind` port for Windows

   If you are not running as root, prepend `sudo` to each command  
 
## Getting Started

Start cloning the GitHub repository:

    git clone https://github.com/UnitexGramLab/unitex-core-tests
    cd unitex-core-tests

Then, set the `UNITEX_BIN` environment variable:
    
    export UNITEX_BIN=/foo/bar/App/UnitexToolLogger
    
## Usage

    Usage:
      unitex-core-test.sh [OPTIONS] [DIRECTORY|ULP_FILE]
    Options:
      -M n    : enable or disable memory error detection tests
                default=0
      -R n    : enable or disable non-regression tests
                default=1
      -s file : create a command line summary log
      -c n    : use or not ANSI color codes
                default=1
      -p n    : print execution logs to stdout
                0 print none
                1 print if error
                2 always print
                default=0
      -d n    : if /dest folder is available, diff original and result files
                0 never diff
                1 diff if RunLog exits with warning(79)
                2 diff if RunLog exits with error(80)
                default=0
      -w n    : width of the log message when executing commands
                default=119
      -v n    : manually set the verbosity level 0...7
                0 (%%) [debug]       debug message
                1 (II) [info]rmation purely informational message
                2 (!!) [notice]      normal but significant condition
                3 (WW) [warning]     warning condition
                4 (EE) [error]       error condition
                5 (CC) [critical]    critical condition
                6 (^^) [alert]       action must be taken immediately
                7 (@@) [panic]       unusable condition
                default=1
      -h      : display this help and exit
      
## Examples

| Command                                                  | Description                                              |
| -------------------------------------------------------- | -------------------------------------------------------- |
| `./unitex-core-test.sh`                                  | Run all non-regression tests                             |
| `./unitex-core-test.sh Compress`                         | Run all `Compress` non-regression tests                  |
| `./unitex-core-test.sh Compress/Compress_bin2.ulp`       | Run `Compress_bin2.ulp` non-regression test              |
| `./unitex-core-test.sh -M1`                              | Run also all memory error detection tests                |
| `./unitex-core-test.sh -M1 Compress`                     | Run also `Compress` memory error detection tests         |
| `./unitex-core-test.sh -M1 Compress/Compress_bin2.ulp`   | Run also `Compress_bin2.ulp` memory error detection test |
| `./unitex-core-test.sh -c0`                              | Disable ANSI color codes                                 |
| `./unitex-core-test.sh -p1`                              | If an error was detetected, print the log to the stdout  |
| `./unitex-core-test.sh -s command_summary.log`           | Create a command line log on `command_summary.log`       |

## Creating Tests

To create a new .ulp test see the section "13.1 Creating log files" on the
[Unitex/GramLab User's Manual](http://releases.unitexgramlab.org/latest-stable/man/).

## Contributing Tests

If your are developing or improving a Unitex Core functionality you can, and should,
contribute tests for it. To contribute: [Fork us](https://github.com/UnitexGramLab/unitex-core-tests/fork)
and [request a pull](https://github.com/UnitexGramLab/unitex-core-tests/pulls) to
the [master branch](https://github.com/UnitexGramLab/unitex-core-tests/tree/master).
    
## Documentation

User's Manual (in PDF format) is available in English and French (more
translations are welcome). You can view and print them with Evince,
downloadable [here](https://wiki.gnome.org/Apps/Evince/Downloads). The
latest version of the User's Manual is accessible
[here](http://releases.unitexgramlab.org/latest-stable/man/).

## Support

Support questions can be posted in the [community support
forum](http://forum.unitexgramlab.org). Please feel free to submit any
suggestions or requests for new features too. Some general advice about
asking technical support questions can be found
[here](http://www.catb.org/esr/faqs/smart-questions.html).

## Reporting Bugs

See the [Bug Reporting
Guide](http://unitexgramlab.org/index.php?page=6) for information on
how to report bugs.

## Governance Model

Unitex/GramLab project decision-making is based on a community
meritocratic process, anyone with an interest in it can join the
community, contribute to the project design and participate in
decisions. The [Unitex/GramLab Governance
Model](http://governance.unitexgramlab.org) describes
how this participation takes place and how to set about earning merit
within the project community.

## Spelling

Unitex/GramLab is spelled with capitals "U" "G" and "L", and with
everything else in lower case. Excepting the forward slash, do not put
a space or any character between words. Only when the forward slash
is not allowed, you can simply write “UnitexGramLab”.

It's common to refer to the Unitex/GramLab Core as "Unitex", and to the
Unitex Project-oriented IDE as "GramLab". If you are mentioning the
distribution suite (Core, IDE, Linguistic Resources and others bundled
tools) always use "Unitex/GramLab".

## License

<a href="/LICENSE"><img height="48" align="left" src="http://www.gnu.org/graphics/empowered-by-gnu.svg"></a>

This program is licensed under the [GNU Lesser General Public License version 2.1](/LICENSE). 
Contact unitex-devel@univ-mlv.fr for further inquiries.

--

Copyright (C) 2021 Université Paris-Est Marne-la-Vallée

[unitex]:  http://unitexgramlab.org
[unitex-core]: https://github.com/UnitexGramLab/unitex-core
