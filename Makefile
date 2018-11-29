all: state_of_jmoab_with_maven.md state_of_the_art.md coming_up_with_the_plan.md head.html tail.html
	cat head.html > slides.html
	cat state_of_jmoab_with_maven.md >> slides.html
	cat state_of_the_art.md >> slides.html
	cat coming_up_with_the_plan.md >> slides.html
	cat tail.html >> slides.html

display: all
	bash display.sh

upload:
	scp -r * moab:/var/opt/moab/slides/migration_b_and_tech
