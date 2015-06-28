call asciidoctor -r asciidoctor-diagram tutorial.adoc -d book -D output
copy 20_getting_started\*.png output
copy 45_setup_monitoring\*.png output
move *.png output
move *.png.cache output
