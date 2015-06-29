set -x
set -e
mkdir -p $HOME/pages/tutorial
BASEDIR=$(dirname $0)
cd $BASEDIR
cp */*.png $HOME/pages/tutorial
asciidoctor -r asciidoctor-diagram tutorial.adoc -d book -D $HOME/pages
ls -R
ls -R $HOME/pages
mv *.png output $HOME/pages/tutorial