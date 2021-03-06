require_relative '../model/entidad_espacial'

class Colision

  def initialize objeto_chocante, objeto_chocado

    ejecutar_choque objeto_chocante, objeto_chocado

  end

  #Resuelvo la colision utilizando metaprogramacion
  #para cada clave de choque me guardo dos metodos y dos argumentos
  #asocio cada metodo con el objeto que lo debera ejecutar
  #y lo llamo con el parametro correspondiente

  def ejecutar_choque objeto_chocante, objeto_chocado

    construir_hash(objeto_chocado, objeto_chocante)
    clave_choque = generar_clave(objeto_chocado, objeto_chocante)
    interaccion = obtener_interaccion(clave_choque)
    llamar_metodos(objeto_chocado, objeto_chocante, interaccion)

  end

  def llamar_metodos(objeto_chocado, objeto_chocante, interaccion)
    metodo_chocante = interaccion[0].bind objeto_chocante
    metodo_chocante.call interaccion[1]
    metodo_chocado = interaccion[2].bind objeto_chocado
    metodo_chocado.call interaccion[3]
  end

  #Este metodo pese a tener solo una linea esta extraido como tal para facilitar la lectura del diagrama de secuencia
  def generar_clave(objeto_chocado, objeto_chocante)
    return ('@' + objeto_chocante.get_representacion + '#' + objeto_chocado.get_representacion)
  end

  def construir_hash(objeto_chocado, objeto_chocante)
    @mapa_efectos = Hash.new
    completar_interacciones_nave(objeto_chocado, objeto_chocante)
    completar_interacciones_misil(objeto_chocado, objeto_chocante)
    completar_interacciones_bomba(objeto_chocado, objeto_chocante)
    completar_interacciones_asteroide(objeto_chocado, objeto_chocante)
    completar_interacciones_estrella(objeto_chocado, objeto_chocante)
  end

  #Este metodo pese a tener solo una linea esta extraido como tal para facilitar la lectura del diagrama de secuencia
  def obtener_interaccion(clave_choque)
    return @mapa_efectos[clave_choque]
  end

  def completar_interacciones_estrella(objeto_chocado, objeto_chocante)
    @mapa_efectos['@estrella#nave'] = [Estrella.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida, Nave.new.method(:aumentar_vida).unbind, objeto_chocante.get_vida]
    @mapa_efectos['@estrella#misil'] = [Estrella.new.method(:aplicar_efecto_nulo).unbind, 0, Misil.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@estrella#bomba'] = [Estrella.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida, Bomba.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@estrella#asteroide'] = [Estrella.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida, Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@estrella#estrella'] = [Estrella.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida, Estrella.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida]
  end

  def completar_interacciones_asteroide(objeto_chocado, objeto_chocante)
    @mapa_efectos['@asteroide#nave'] = [Asteroide.new.method(:aumentar_masa).unbind, objeto_chocado.get_masa/10, Nave.new.method(:disminuir_masa).unbind, objeto_chocante.get_masa/2]
    @mapa_efectos['@asteroide#misil'] = [Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0, Misil.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@asteroide#bomba'] = [Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0, Bomba.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida]
    @mapa_efectos['@asteroide#asteroide'] = [Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0, Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@asteroide#estrella'] = [Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0, Estrella.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida]
  end

  def completar_interacciones_bomba(objeto_chocado, objeto_chocante)
    @mapa_efectos['@bomba#nave'] = [Bomba.new.method(:disminuir_vida).unbind, 100, Nave.new.method(:disminuir_vida).unbind, 50]
    @mapa_efectos['@bomba#misil'] = [Bomba.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida/2, Misil.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@bomba#bomba'] = [Bomba.new.method(:disminuir_vida).unbind, 100, Bomba.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@bomba#asteroide'] = [Bomba.new.method(:disminuir_vida).unbind, objeto_chocante.get_vida, Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@bomba#estrella'] = [Bomba.new.method(:disminuir_vida).unbind, 100, Estrella.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida]
  end

  def completar_interacciones_misil(objeto_chocado, objeto_chocante)
    @mapa_efectos['@misil#nave'] = [Misil.new.method(:disminuir_vida).unbind, 100, Nave.new.method(:disminuir_vida).unbind, 80]
    @mapa_efectos['@misil#misil'] = [Misil.new.method(:disminuir_vida).unbind, 100, Misil.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@misil#bomba'] = [Misil.new.method(:aplicar_efecto_nulo).unbind, 0, Bomba.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida/2]
    @mapa_efectos['@misil#asteroide'] = [Misil.new.method(:aplicar_efecto_nulo).unbind, 0, Asteroide.new.method(:aplicar_efecto_nulo).unbind, 0]
    @mapa_efectos['@misil#estrella'] = [Misil.new.method(:aplicar_efecto_nulo).unbind, 0, Estrella.new.method(:aplicar_efecto_nulo).unbind, 0]
  end

  def completar_interacciones_nave(objeto_chocado, objeto_chocante)
    @mapa_efectos['@nave#nave'] = [Nave.new.method(:disminuir_vida).unbind, 100, Nave.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@nave#misil'] = [Nave.new.method(:disminuir_vida).unbind, 80, Misil.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@nave#bomba'] = [Nave.new.method(:disminuir_vida).unbind, 50, Bomba.new.method(:disminuir_vida).unbind, 100]
    @mapa_efectos['@nave#asteroide'] = [Nave.new.method(:disminuir_masa).unbind, objeto_chocado.get_masa/2, Asteroide.new.method(:aumentar_masa).unbind, objeto_chocante.get_masa/10]
    @mapa_efectos['@nave#estrella'] = [Nave.new.method(:aumentar_vida).unbind, objeto_chocado.get_vida, Estrella.new.method(:disminuir_vida).unbind, objeto_chocado.get_vida]
  end


end