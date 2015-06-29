vagrant up
echo open http://localhost:4000/saltconsul-examples/ in the browser!
vagrant ssh -c "cd /vagrant; jekyll server --watch -P 4000 -H `hostname` --force_polling"