// INSCRIPCION A CURSOS

class Estilo {
    const esRelajante

    method esRelajante() = esRelajante
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

    method requisitoAdicional(estudiante) { return } // preguntar
}

class CursoBase inherits Curso {
    method cantEstilosDominadosRequeridos() = 1

    override method requisitoAdicional(estudiante) {
        return self.requisitoEstilo(estudiante) || self.requisitoDocenteConTitulo()
    }

    method requisitoEstilo(estudiante) = estudiante.cantEstilosDominados() >= self.cantEstilosDominadosRequeridos()

    method requisitoDocenteConTitulo() = docenteAsignado.esGuardavida()
}

class CursoEscuelita inherits CursoBase {
    method edadLímite() = 13

    override method requisitoAdicional(estudiante) {
        return super(estudiante) && self.requisitoDeEdad(estudiante)
    }

    method requisitoDeEdad(estudiante) = estudiante.edad() < self.edadLímite()
}

class CursoTerapéutico inherits CursoBase {
    method cantEstilosRelajantesRequeridos() = 1

    //var recaudaciónBruta

    override method requisitoAdicional(estudiante) {    
        return super(estudiante) && self.requisitoEstiloRelajante(estudiante)
    }

    method requisitoEstiloRelajante(estudiante) = estudiante.cantEstilosRelajantesDominados() >= self.cantEstilosRelajantesRequeridos()
}

class Docente { // abstracta
    const esGuardavida

    method esGuardavida() = esGuardavida

    method puedeDictar(estudiante, curso)
}

class DocenteDedicado inherits Docente {
    const estilo

    method estilo() = estilo

    override method puedeDictar(estudiante, curso) = estudiante.dominaEstilo( self.estilo() )
}

class DocenteExterno inherits Docente {
    const límiteMáximoEstudiantes
    
    method límiteMáximoEstudiantes() = límiteMáximoEstudiantes

    method edadLímite() = 13

    override method puedeDictar(estudiante, curso) = curso.cantidadInscriptosMenores( self.edadLímite() ) < self.límiteMáximoEstudiantes() 
}

class DocenteBásico inherits Docente {
    override method puedeDictar(estudiante, curso) = true
}

// RECAUDACION
