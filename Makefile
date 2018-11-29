all: slides.md head.html tail.html
	cat head.html > slides.html
	cat slides.md >> slides.html
	cat tail.html >> slides.html

upload:
	scp -r * moab:/var/opt/moab/slides/migration_b_and_tech
