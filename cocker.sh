Programa para controlar la caldera

Teclear: "./cocker.sh acción"

Listado de acciones
    -enciende: para encender
    -apaga: para apagar
    -estado: muestra si la caldera funciona en este momento
    -ayuda: muestra esta ayuda

Algunos ejemplos: 
    ./cocker.sh  enciende
    ./cocker.sh  apaga
    ./cocker.sh  estado
root@raspberrypi:~/scripts# vi cocker.sh 
root@raspberrypi:~/scripts# cat cocker.sh 
#!/usr/bin/env bash
RELAY_PIN=26

function print_help(){
	my_name=$0
	echo "Programa para controlar la caldera"
	echo ""
	echo "Teclear: \""$my_name "acción\""
	echo ""
	echo "Listado de acciones"
	echo "    -enciende: para encender"
	echo "    -apaga: para apagar"
	echo "    -estado: muestra si la caldera funciona en este momento"
	echo "    -ayuda: muestra esta ayuda"
	echo ""
	echo "Algunos ejemplos: "
	echo "    "$my_name " enciende"
	echo "    "$my_name " apaga"
	echo "    "$my_name " estado"
}

function get_status(){
	return $(gpio read $RELAY_PIN)
}
function print_status(){
	get_status
	status=$?

	case $status in
	0)
		echo "caldera encendida"
		;;
	1)
		echo "caldera apagada"
		;;
	*)
		echo "caldera en estado indeterminado"
		;;
	esac
}

function turn_on(){
	get_status
	status=$?

	if [[ $status -eq 0 ]]
	then
		echo "la caldera ya estaba encendida, no se hace nada"
	else
		gpio mode $RELAY_PIN out
		print_status
	fi
}

function turn_off(){
	get_status
	status=$?

	if [[ $status -eq 1 ]]
	then
		echo "la caldera ya estaba apagada, no se hace nada"
	else
		gpio mode $RELAY_PIN in
		print_status
	fi
}

case $1 in
	"enciende")
		turn_on
		;;
	"apaga")
		turn_off
		;;
	"estado")
		print_status
		;;
	ayuda|help|-h)
		print_help	
		;;
	*)
		print_help
esac
