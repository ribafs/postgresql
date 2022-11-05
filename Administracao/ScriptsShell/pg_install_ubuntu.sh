echo -n "Digite o diretório onde descompactou o PostgreSQL. Ex.: postgresql-8.2 "
read dir
sudo apt-get install build-essential
sudo apt-get install libreadline-dev
sudo apt-get install zlib1g-dev
sudo apt-get install gettext

cd /usr/local/src/$dir
./configure
make
sudo make install
sudo groupadd postgres
sudo useradd -g postgres -d /usr/local/pgsql postgres
sudo mkdir /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data
sudo passwd postgres
su - postgres (fazer login como postgres)
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
exit

sudo cp /usr/local/src/$dir/contrib/start-script/linux para /etc/init.d/postgresql
sudo chmod u+x /etc/init.d/postgresql

# sudo gedit .bash_bashrc
# PATH=/usr/local/pgsql/bin:$PATH