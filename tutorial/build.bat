call asciidoctor -r asciidoctor-diagram tutorial.adoc -d book -D output
mkdir output\tutorial
copy 20_getting_started\*.png output\tutorial
copy 45_setup_monitoring\*.png output\tutorial
move tutorial\*.png output\tutorial
move tutorial\*.png.cache output\tutorial
