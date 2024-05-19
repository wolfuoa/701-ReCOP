import os
from subprocess import call

os.chdir(os.path.abspath("./test/scripts"))
call(["vsim", "-do", "compile.do"])
