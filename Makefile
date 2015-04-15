export PATH:=/sbin:/usr/sbin:${PATH}

view:
	mkdir -p dist
	./spec.sh
	pdflatex --output-directory dist voorblad.tex; xpdf dist/voorblad.pdf

prepare:
	sudo apt-get install texlive texlive-latex-extra xpdf 

clean:
	rm -rf dist/*.aux dist/*.log dist/*.toc dist/*.dvi dist/*.out dist/*.tmp
	mkdir -p dist
	rm *.aux *.lg *.4* *.image.* *.htoc *.html *.css *.dvi *.haux *.pdf *.log *.out *.idv *.tmp
