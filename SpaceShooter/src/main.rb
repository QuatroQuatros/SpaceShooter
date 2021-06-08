require "ruby2d"

set fps_cap: 20
set width: 512
set height: 576
set title: "Meteor Hater"
bullets = []

fundo = Sprite.new(
	"../assets/Backgrounds/space.png",
	width: 512,
	height: 576,
	clip_width:64,
	time:300,
	loop:true
)

placar = Sprite.new(
	"../assets/Score/score.png",
	width: 141, height: 60,x: 371
	)

class Ship
	def initialize
		@nave = Image.new(
			"../assets/Ships/ship.png",
			width: 96,
			height: 96,
			x: 208,
			y: 480
		)
	end
	def move(key)
		case key
		when 'up', 'w'
			unless (@nave.y < 0)
				@nave.y -= 10
			end
		when 'down', 's'
			unless (@nave.y + @nave.height > Window.height)
				@nave.y += 10
			end
		when 'left', 'a'
			unless @nave.x < 0
				@nave.x -= 10
			end
		when 'right', 'd'
			unless (@nave.x + @nave.width > Window.width)
			 	@nave.x += 10
			 end	
		end
	end

	def x
		@nave.x
	end

	def y
		@nave.y
	end

end

class Bullet
	attr_accessor :bullet
	def initialize(x, y)
		@bullet = Sprite.new(
			"../assets/Ships/laser.png",
			width: 24,height: 32,
			x: x + 36,y: y - 28
		)
	end

end


class Enemy
	attr_accessor :enemy, :have_enemy
	def initialize
		enemys_path = ["meteor.png", "meteor2.png"]
		e = rand(0..1)
		x = rand(30..440)/10 * 10
		@have_enemy = true
		@enemy = Sprite.new(
			"../assets/Enemys/" + enemys_path[e],
			width: 96, height: 96,
			x: x, y: -40
		)
	end

	def have_enemy?
		@have_enemy
	end
end

class Game
	attr_accessor :score
	def initialize
		@score = 0
		@end = false
		@points = Text.new(@score, color: 'white', x: 435, y: 10, size: 25)
	end

	def update_bullet(bullets)
		bullets.each do |b|
			b.bullet.y -= 10
			if b.bullet.y < -30
				bullets.delete(b)
				b.bullet.remove
			end
		end
	end

	def update_enemys(e)
		e.enemy.y += 15
		if e.enemy.y > 600
			e.have_enemy = false
			e.enemy.remove
		end
	end

	def update_score
		@points.remove
		@points = Text.new(@score, color: 'white', x: 430, y: 10, size: 25)
	end

	def bullet_colide?(bullets, e)
		bullets.each do |b|
			#return b.bullet.x <= e.enemy.x + 60 && b.bullet.x >= e.enemy.x && b.bullet.y <= e.enemy.y - 20 
			#return b.bullet.contains?(b.bullet.x, e.enemy.x) && b.bullet.contains?(b.bullet.x, e.enemy.y) && b.bullet.contains?(b.bullet.y, e.enemy.y) 
			if((e.enemy.x + e.enemy.width > b.bullet.x) &&
				(b.bullet.x < e.enemy.x + e.enemy.width)&&
				(e.enemy.y + e.enemy.height > b.bullet.y) &&
				(b.bullet.y < e.enemy.y + e.enemy.height))
				return true
			else
				return false 
			end
		end	
	end
end

game = Game.new
nave = Ship.new
enemy = Enemy.new

on :key_held do |event|
	if ['up', 'left', 'right', 'down', 'a', 's', 'd', 'w'].include?(event.key)
		nave.move(event.key)
  	end
end

on :key_down do |event|
	if event.key == "space"
		b = Bullet.new(nave.x, nave.y)
		bullets.push(b)
	end
end

update do
	fundo.play
	game.update_bullet(bullets)
	game.update_score

	if game.bullet_colide?(bullets, enemy) == true
		enemy.enemy.remove
		enemy = Enemy.new
		bullets[-1].bullet.remove
		bullets.pop
		game.score += 5
	end


	if enemy.have_enemy?
		game.update_enemys(enemy)
	else
		enemy = Enemy.new
	end
end
show
