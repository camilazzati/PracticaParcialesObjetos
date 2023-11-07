object abc {
	
	
}
 


// ----------------------------------------------------
// USUARIO
// ----------------------------------------------------

object usuarios { // objeto comapniero de una clase, para poder hacer consultas de todos los usuarios
	const todosLosUsuarios = []
	
	method emailUsuariosRicos(){
		return todosLosUsuarios.dilter{usuario => usuario.verificado()}
		.sortedBy{uno, otro => uno.saldoTotal() > otro.saltoTotal()}
		.take(100).map{usuario => usuario.email()}
	}
	
	method cantidadDeSuperUsuarios(){
		return todosLosUsuarios.count{usuario => usuario.esSuperUsuario()}
	}
}

class Usuario {
	const property nombre
	const property email
	var property verificado = false
	const contenidos = []
	
	method saldoTotal(){
		return contenidos.sum { contenido => contenido.recaudacion()}
	}
	
	method esSuperUsuario(){
		return contenidos.count{contenido => contenido.esPopular()}
	}
	
	method publicar(unContenido, monetizacion){
		if(unContenido.puedePublicarse()) {
			contenidos.add(unContenido)
			unContenido.monetizacion(monetizacion)
		}
	}
}







