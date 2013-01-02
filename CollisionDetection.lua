function checkCollision(ax1, ay1, aw, ah, bx1, by1, bw, bh)
	local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
	return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function resolveEnemyHit(enemy, dmg)
	enemy.hp = enemy.hp - dmg or 0
end

function resolvePlayerHit(dmg)
	player.hp = player.hp - dmg
end

function checkEnemyCollisions(dt)
	for i = 1, table.maxn(player[level.current].bullet) do
		if player[level.current].bullet[i] then
			player[level.current].bullet[i].lifespan = player[level.current].bullet[i].lifespan + dt
			if player[level.current].bullet[i].lifespan > player.bulletLife then
				player[level.current].bullet[i] = false
			else
				for j = 1, table.maxn(enemies[level.current].enemy) do
					if enemies[level.current].enemy[j] and player[level.current].bullet[i] then
						if checkCollision(player[level.current].bullet[i].xPos, player[level.current].bullet[i].yPos, 5, 5, enemies[level.current].enemy[j].xPos, enemies[level.current].enemy[j].yPos, 32, 32) then
							resolveEnemyHit(enemies[level.current].enemy[j], 10)
							if enemyDead(enemies[level.current].enemy[j]) then
								enemies[level.current].enemy[j] = false
							end
							player[level.current].bullet[i] = false
							break
						end
					end
				end
				if player[level.current].bullet[i] then
					updateBulletPosition(i, dt)
				end
			end
		end
	end
end