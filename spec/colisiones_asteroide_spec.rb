require 'rspec'
require 'spec_helper'
require_relative '../model/entidad_espacial'
require_relative '../model/nave'
require_relative '../model/misil'
require_relative '../model/bomba'
require_relative '../model/asteroide'
require_relative '../model/estrella'
require_relative '../model/colision'

describe 'Colisiones del asteroide' do


  #Asteroide-nave
  it 'el asteroide deberia aumentar su masa en un 10% de la masa de la nave al chocarla' do

    asteroide_chocante = Asteroide.new
    nave_chocada = Nave.new
    asteroide_chocante.colisionar_con nave_chocada
    expect(asteroide_chocante.get_masa).to eq 110

  end

end
