# To make the targets below, you should first run pip install requirements-dev.txt

.PHONY: check, tcheck, pycodestyle, pyflakes, lint, wc, clean, clobber, upload

check:
	env PYTHONPATH=. pytest

tcheck:
	env PYTHONPATH=. trial --rterrors test

pycodestyle:
	find . -path './.tox' -prune -o -path './build' -prune -o -path './dist' -prune -o -name '*.py' -print0 | xargs -0 pycodestyle

pyflakes:
	find .  -path './.tox' -prune -path './build' -prune -o -path './dist' -prune -o -name '*.py' -print0 | xargs -0 pyflakes

lint: pycodestyle pyflakes

wc:
	find . -path './.tox' -prune -o -path './build' -prune -o -path './dist' -prune -o \( -name '*.py' -o -name '*.sh' \) -print0 | xargs -0 wc -l

clean:
	find . \( -name '*.pyc' -o -name '*~' \) -print0 | xargs -0 rm
	find . -name __pycache__ -type d -print0 | xargs -0 rmdir
	find . -name _trial_temp -type d -print0 | xargs -0 rm -r
	find . -name .pytest_cache -type d -print0 | xargs -0 rm -r
	python setup.py clean
	rm -fr sausage_machine.egg-info dist

# The upload target requires that you have access rights to PYPI.
upload:
	python setup.py sdist
	export PYTHONPATH=`pwd`; twine upload dist/sausage-machine-$$(bin/sausage-machine-version.py).tar.gz
