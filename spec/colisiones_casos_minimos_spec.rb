require 'rspec'
require 'spec_helper'
require_relative '../model/entidad_espacial'
require_relative '../model/nave'
require_relative '../model/misil'
require_relative '../model/bomba'
require_relative '../model/asteroide'
require_relative '../model/estrella'
require_relative '../model/colision'

describe 'Casos minimos de colisiones enviados por el profesor' do

  #Solo para estos casos estoy usando cuatro expects por spec, ya que cada spec representa
  #uno de los casos de prueba enviados por el profesor

  #Caso minimo: nave vs asteroide
  it 'deberia resolver correctamente la colision nave 100-100 vs asteroide 50-100' do

    nave_chocante = Nave.new
    asteroide_chocado = Asteroide.new
    asteroide_chocado.set_vida 50
    nave_chocante.colisionar_con asteroide_chocado
    expect(nave_chocante.get_vida).to eq 100
    expect(nave_chocante.get_masa).to eq 50
    expect(asteroide_chocado.get_vida).to eq 50
    expect(asteroide_chocado.get_masa).to eq 110

  end

  #Caso minimo: estrella vs misil
  it 'deberia resolver correctamente la colision estrella 50-10 vs misil 10-30' do

    estrella_chocante = Estrella.new
    misil_chocado = Misil.new
    estrella_chocante.set_vida 50
    estrella_chocante.set_masa 10
    misil_chocado.set_vida 10
    misil_chocado.set_masa 30
    estrella_chocante.colisionar_con misil_chocado
    expect(estrella_chocante.get_vida).to eq 50
    expect(estrella_chocante.get_masa).to eq 10
    expect(misil_chocado.get_vida).to eq 10
    expect(misil_chocado.get_masa).to eq 30

  end

end
