
PROJECT	= homework-3
SOURCES	= ${PROJECT}.tex	\
		../common.tex

.PHONY: clean

all: ${PROJECT}.pdf



${PROJECT}.pdf: ${SOURCES}
	pdflatex ${PROJECT}
	-bibtex ${PROJECT}
	pdflatex ${PROJECT}
	pdflatex ${PROJECT} 


clean:
	-rm $$(ls ${PROJECT}.* | grep -v "${PROJECT}.tex") 2>/dev/null || true


