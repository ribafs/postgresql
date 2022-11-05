echo -n "Digite o diretório onde descompactou o PostgreSQL. Ex.: postgresql-8.2 "
read dir

cd /usr/local/src/$dir
./configure
gmake
gmake install
groupadd postgres
useradd -g postgres -d /usr/local/pgsql postgres
mkdir /usr/local/pgsql/data
chown postgres:postgres /usr/local/pgsql/data
passwd postgres
su - postgres (fazer login como postgres)
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
exit

cp /usr/local/src/$dir/contrib/start-script/linux para /etc/init.d/postgresql
chmod u+x /etc/init.d/postgresql

# mcdit /etc/profile
# PATH=/usr/local/pgsql/bin:$PATH