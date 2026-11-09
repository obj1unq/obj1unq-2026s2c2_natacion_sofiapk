class Estilo {
    const esRelajante

    const descuento

    method esRelajante() = esRelajante

    method descuento() = descuento
}

class Estudiante {
    const estilosDominados = #{}
    const edad

    method estilosDominados() = estilosDominados

    method cantEstilosDominados() = estilosDominados.size()

    method edad() = edad

    method inscribirseA(curso) {
        curso.inscribirEstudiante(self)
    }

    method dominaEstilo(estilo) = estilosDominados.contains(estilo)

    method cantEstilosRelajantesDominados() = estilosDominados.count( { estilo => estilo.esRelajante() } )

    method descuentosSegunEstilosDominados() = estilosDominados.sum( { estilo => estilo.descuento() } )
}

class Curso {
    const estudiantesInscriptos = #{}
    const docenteAsignado
    const cupoMáximo

    method docenteAsignado() = docenteAsignado

    method cupoMáximo() = cupoMáximo

    method estudiantesInscriptos() = estudiantesInscriptos // requerimiento

    method inscribirEstudiante(estudiante) { // requerimiento
        self.validarInscribirEstudiante(estudiante)
        estudiantesInscriptos.add(estudiante)
    }

    method validarInscribirEstudiante(estudiante) { // requerimiento
        if ( not self.puedeInscribir(estudiante) ) {
            self.error( "No se puede inscribir a " + estudiante )
        }
    }

    method puedeInscribir(estudiante) {
        return  not self.estáInscripto(estudiante) &&
                self.hayVacantesDisponibles() &&
                self.docenteEstáHabilitadoParaDictarCurso(estudiante, self) &&
                self.requisitoAdicional(estudiante)
    }

    method estáInscripto(estudiante) = estudiantesInscriptos.contains(estudiante) 

    method hayVacantesDisponibles() = self.cantidadInscriptos() < cupoMáximo 

    method cantidadInscriptos() = estudiantesInscriptos.size() 

    method docenteEstáHabilitadoParaDictarCurso(estudiante, curso) {
        return docenteAsignado.puedeDictar(estudiante, curso)
    }

    method cantidadInscriptosMenores(edad) = estudiantesInscriptos.count( { estudiante => estudiante.edad() < edad } )

    method requisitoAdicional(estudiante) { return true } // preguntar

    method recaudaciónBruta()

    method recaudaciónDelCurso() = self.recaudaciónBruta() - self.honorariosDelDocente()

    method honorariosDelDocente() = docenteAsignado.honorariosPorCurso(self)

    method existeAlgúnEstudianteQueDominaElEstilo(estilo) {
        return estudiantesInscriptos.any( { estudiante => estudiante.dominaEstilo(estilo) } )
    }

    method esCursoInfantil() {
        return estudiantesInscriptos.all( { estudiante => estudiante.edad() < 13 } )
    }
}

class CursoBase inherits Curso {
    method cantEstilosDominadosRequeridos() = 1

    override method requisitoAdicional(estudiante) {
        return self.requisitoEstilo(estudiante) || self.requisitoDocenteConTitulo()
    }

    method requisitoEstilo(estudiante) = estudiante.cantEstilosDominados() >= self.cantEstilosDominadosRequeridos()

    method requisitoDocenteConTitulo() = docenteAsignado.esGuardavida()

    override method recaudaciónBruta() {
        return estudiantesInscriptos.sum( { estudiante => 20 - estudiante.descuentosSegunEstilosDominados() } )
    }
}

class CursoEscuelita inherits CursoBase {
    method edadLímite() = 13

    override method requisitoAdicional(estudiante) {
        return super(estudiante) && self.requisitoDeEdad(estudiante)
    }

    method requisitoDeEdad(estudiante) = estudiante.edad() < self.edadLímite()

    override method recaudaciónBruta() {
        return super() + self.incentivoMunicipal()
    }

    method incentivoMunicipal() = 500
}

class CursoTerapéutico inherits Curso {
    const recaudaciónBruta

    method cantEstilosRelajantesRequeridos() = 1

    override method requisitoAdicional(estudiante) {    
        return super(estudiante) && self.requisitoEstiloRelajante(estudiante)
    }

    method requisitoEstiloRelajante(estudiante) {
        return estudiante.cantEstilosRelajantesDominados() >= self.cantEstilosRelajantesRequeridos()
    }

    override method recaudaciónBruta() = recaudaciónBruta
}

class Docente { // abstracta
    const esGuardavida

    method esGuardavida() = esGuardavida

    method puedeDictar(estudiante, curso)

    method honorariosPorCurso(curso) = self.honorariosBase() + self.porcentajeDeRecaudaciónDelCurso(curso)

    method honorariosBase() = 20 

    method porcentajeDeRecaudaciónDelCurso(curso) = curso.recaudaciónBruta() * self.porcentaje() 

    method porcentaje() = 0.1
}

class DocenteDedicado inherits Docente {
    const estilo

    method estilo() = estilo

    override method puedeDictar(estudiante, curso) = estudiante.dominaEstilo( self.estilo() )

    override method porcentaje() = 0.15
}

class DocenteExterno inherits Docente {
    const límiteMáximoEstudiantes
    
    method límiteMáximoEstudiantes() = límiteMáximoEstudiantes

    method edadLímite() = 13

    override method puedeDictar(estudiante, curso) { 
        return curso.cantidadInscriptosMenores( self.edadLímite() ) < self.límiteMáximoEstudiantes() 
    }

    override method honorariosPorCurso(curso) {
        return super(curso) + self.extraPorCadaInscriptoAlCurso(curso)
    }

    method extraPorCadaInscriptoAlCurso(curso) = self.valorExtra() * curso.cantidadInscriptos()

    method valorExtra() = 3

}

class DocenteBásico inherits Docente {
    override method puedeDictar(estudiante, curso) = true
}

class Escuela {
    var dineroGuardado
    const cursos = #{}

    method cursos() = cursos

    method dineroGuardado() = dineroGuardado

    method cobrarRecaudaciónMensual(){
        dineroGuardado += self.recaudaciónMensual()
    }

    method recaudaciónMensual(){ // suma de las recaudaciones de todos los cursos
        return cursos.sum( { curso => curso.recaudaciónDelCurso() } )
    }

    method cursoConElEstilo(estilo) {
        return cursos.find( { curso => curso.existeAlgúnEstudianteQueDominaElEstilo(estilo) } )
    }

    method cursosInfantiles() {
        return cursos.filter( { curso => curso.esCursoInfantil() } )
    }

    method docentesDeCursosInfantiles() {
        return self.cursosInfantiles().map( { curso => curso.docenteAsignado() } ).asSet()
    }

}