Cadena de Favores
====================

# Instalación

* Ejecutar el comando
<tt>$ git clone https://github.com/shk33/cadena-favores.git</tt>

* Moverse a la carpeta del proyecto
<tt>cd cadena-favores</tt>.

* Ejecutar el comando 
<tt>bundle install</tt>.

* Abrir el archivo <tt>config/application.example.yml</tt>.
<tt>DATABASE_NAME: "cadena_favores"
DATABASE_USERNAME: "postgres"
DATABASE_PASSWORD: "password"
DATABASE_HOST: "127.0.0.1" </tt>

* Modifcar los valores DATABASE_USERNAME y DATABASE_PASSWORD con la configuración de su computadora de Postgress.

* Duplicar el archivo <tt>config/application.example.yml</tt> y al archivo duplicado renombrarlo <tt>config/application.yml</tt>


* Ejecutar el comando
<tt>rake db:setup</tt>

* Ejecutar el comando
<tt>rails server</tt>.

* Visitar la página en locahost:3000
