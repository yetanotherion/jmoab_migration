all: 01_state_of_jmoab_with_maven.md 02_state_of_the_art.md 03_coming_up_with_the_plan.md 04_mixing_maven_and_gradle.md 05_big_bang.md 00_head.html 06_journey_to_the_converter.md 99_tail.html
	cat 00_head.html > slides.html
	cat 01_state_of_jmoab_with_maven.md >> slides.html
	cat 02_state_of_the_art.md >> slides.html
	cat 03_coming_up_with_the_plan.md >> slides.html
	cat 04_mixing_maven_and_gradle.md >> slides.html
	cat 05_big_bang.md >> slides.html
	cat 06_journey_to_the_converter.md >> slides.html
	cat 99_tail.html >> slides.html

display: all
	bash display.sh

upload:
	scp -r * moab:/var/opt/moab/slides/migration_b_and_tech
