.PHONY: deps test build publish

all: deps test build

deps:
	mkdir -p ./output
	#pip3 uninstall -y pipenv
	#pip3 install --upgrade -r requirements.txt
	pip3 install -r requirements.txt
	PYTHON_BIN_PATH="$(python3 -m site /var/lib/jenkins/.local/bin"
        PATH="$PATH:$PYTHON_BIN_PATH"
	pipenv install

test:
	nose2 -v --with-coverage --coverage takehome --coverage-report term-missing --coverage-report html tests 2>&1 | tee ./output/python-test.out
	tar czvf ./output/python-coverage.tar.gz .coverage ./htmlcov

build:
	python3 setup.py sdist --dist-dir ./output bdist_wheel
	# tar czvf ./output/python-artefact.tar.gz ./takehome

publish:
	if [[ "$(git branch --show-current)" -ne "master" ]]; then exit 1; fi
