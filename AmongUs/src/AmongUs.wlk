// ---------------------------------------------------------
// JUGADORES
// ---------------------------------------------------------

class Jugador {
	var color
	const mochila = #{}
	var nivelDeSospecha = 40
	const tareasARealizar = #{}
	var nave
		
		
	method esSospechoso() = nivelDeSospecha > 50
	
	method buscar(item){
		mochila.add(item)
	}
	
	method realizarTarea(tarea)
	
	method tieneItem(item) = mochila.contains(item)
	
	method aumentarSospecha(cantidad){
		nivelDeSospecha += cantidad
	}
	
	method disminuirSospecha(cantidad){
		nivelDeSospecha -= cantidad
	}
	
	method realizoTodasLasTareas()
	
	method realizarTareaPendiente(){
		self.realizarTarea(tareasARealizar.anyOne())
	}
	
	method votar()
	
	method mochilaVacia() = mochila.isEmpty()
}

class Tripulante inherits Jugador{
	var personalidad
	
	
	override method realizarTarea(tarea){
		tarea.realizar(self, nave)
		tareasARealizar.remove(tarea)
	}
	
	override method realizoTodasLasTareas(){
		return tareasARealizar.isEmpty()
	}
	
	override method votar(){
		votos.add(personalidad.votar(nave.tripulantes()))
		
	}
	
}

class Impostor inherits Jugador{
	
	override method realizoTodasLasTareas() = true
	
	method realizarSabotaje(sabotaje){
		sabotaje.realizar(self, nave) // otroJugador?
	}
	
	override method votar(){
		votos.add(nave.tripulantes().anyOne())
	}
}


const votoBlanco = #{}

// ---------------------------------------------------------
// PERSONALIDADES
// ---------------------------------------------------------

object troll{
	
	method votar(tripulantes){
		return tripulantes.findOrDefault( {tripulante => !tripulante.esSospechoso()}.anyOne() , votoBlanco)
		
	}
}

object detective{
	
	method votar(tripulantes){
		return tripulantes.max{ tripulante => tripulante.nivelDeSospecha()} // tripulantes.findOrDefault( {tripulante => !tripulante.maxNivelDeSospecha()} , votoBlanco)
	}
}

object materialista{
	
	method votar(tripulantes){
		return tripulantes.findOrDefault( {tripulante => tripulante.mochilaVacia()}.anyOne() , votoBlanco)
		//return tripulantes.filter{tripulante => tripulante.mochilaVacia()}.anyOne()
	}
}



// ---------------------------------------------------------
// TAREAS
// ---------------------------------------------------------

object arreglarTableroElectrico{
	
	method realizar(unJugador, nave){
		if(unJugador.tieneItem(llaveIngles)){ // esto hacerlo en la nave
			unJugador.aumentarSospecha(10)
		}
	}
}

object sacarBasura{
	
	method realizar(unJugador, nave){
		if(unJugador.tieneItem(escoba) && unJugador.tieneItem(bolsaDeConsorcio)){
			unJugador.disminuirSospecha(4)
		}
	}
}

object ventilarNave{
	
	method realizar(unJugador, nave){
		nave.aumentarOxigeno(5)
	}
}

// ---------------------------------------------------------
// SABOTAJES
// ---------------------------------------------------------

object reducirOxigeno{
	
	method realizar(unJugador, nave, otroJugador){
		unJugador.aumentarSospecha(5)
		nave.disminuirOxigeno(10)
	}
}

object impugnarAUnJugador{
	
	method realizar(unJugador, nave, otroJugador){
		unJugador.aumentarSospecha(5)
		otroJugador.obligarAVotarEnBlanco()
	}
}




// ---------------------------------------------------------
// NAVE
// ---------------------------------------------------------

object nave{
	const tripulantes = #{}
	var property oxigeno
	const votos = #{}
	
	method todasLasTareasFueronRealizadas(){
		return tripulantes.all {tripulante => tripulante.realizoTodasLasTareas()}
	}
	
	method ganaronLosTripulantes(){
		if(self.todasLasTareasFueronRealizadas()){
			self.error("Ganaron los tripulantes")
		}
	}
	
	method aumentarOxigeno(cantidad){
		oxigeno += cantidad
	}
	
	method disminuirOxigeno(cantidad){
		oxigeno -= cantidad
		if(oxigeno <= 0){
			self.error("Ganaron los impostores")
		}
	}
	
	method llamarReunionDeEmergencia(){
		tripulantes.forEach{tripulante => tripulante.votar()} // mapear al jugador que votaron
		self.expulsar()
		
	}
	
	method jugadorMasVotado(){
		const masVotado = tripulantes.max{unJugador => votos.ocurrencesOf(unJugador)}
		self.expulsar(masVotado)
	}
	
	method expulsar(unTripulante){
		
		tripulantes.remove(unTripulante)
		// max con ocurrencesOf

		// que por cada tripulante cuante la cantidad de veces que aparece en la lista de votos y de esos elegir el maximo
	}
	
}














