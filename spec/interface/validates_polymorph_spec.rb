require 'spec_helper'

describe Polymorpheus::Interface::ValidatesPolymorph do
  let(:hero) { Hero.create! }
  let(:villain) { Villain.create! }

  before do
    create_table(:story_arcs) do |t|
      t.references :hero
      t.references :villain
    end
    create_table(:story_arc_nullables) do |t|
      t.references :hero
      t.references :villain
    end
    create_table(:heros)
    create_table(:villains)
  end

  specify { expect(StoryArc.new(character: hero).valid?).to eq(true) }
  specify { expect(StoryArc.new(character: villain).valid?).to eq(true) }
  specify { expect(StoryArc.new(hero_id: hero.id).valid?).to eq(true) }
  specify { expect(StoryArc.new(hero: hero).valid?).to eq(true) }
  specify { expect(StoryArc.new(hero: Hero.new).valid?).to eq(true) }

  specify { expect(StoryArcNullable.new(character: hero).valid?).to eq(true) }
  specify { expect(StoryArcNullable.new(character: villain).valid?).to eq(true) }
  specify { expect(StoryArcNullable.new(hero_id: hero.id).valid?).to eq(true) }
  specify { expect(StoryArcNullable.new(hero: hero).valid?).to eq(true) }
  specify { expect(StoryArcNullable.new(hero: Hero.new).valid?).to eq(true) }

  it 'is invalid if no association is specified' do
    story_arc = StoryArc.new
    expect(story_arc.valid?).to eq(false)
    expect(story_arc.errors[:base]).to eq(
      ["You must specify exactly one of the following: {hero, villain}"]
    )
  end

  it 'is invalid if multiple associations are specified' do
    story_arc = StoryArc.new(hero_id: hero.id, villain_id: villain.id)
    expect(story_arc.valid?).to eq(false)
    expect(story_arc.errors[:base]).to eq(
      ["You must specify exactly one of the following: {hero, villain}"]
    )
  end

  it 'is valid if no association is specified with nullable option' do
    story_arc = StoryArcNullable.new
    expect(story_arc.valid?).to eq(true)
  end

  it 'is valid if one association is specified with nullable option' do
    story_arc = StoryArcNullable.new(villain_id: villain.id)
    expect(story_arc.valid?).to eq(true)
  end

  it 'is invalid if multiple associations are specified with nullable option' do
    story_arc = StoryArcNullable.new(hero_id: hero.id, villain_id: villain.id)
    expect(story_arc.valid?).to eq(false)
    expect(story_arc.errors[:base]).to eq(
                                         ["You must specify at most one of the following: {hero, villain}"]
                                       )
  end
end
