function onCreate()
	
	for i = 0, getProperty('unspawnNotes.length')-1 do
		
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Warning Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'warningNote');
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.023'); 
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '1'); 
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then 
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); 
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Warning Note' then
		playSound('shooters', 1);
		characterPlayAnim('dad', 'shoot', true);
		characterPlayAnim('boyfriend', 'dodge', true);
		setProperty('boyfriend.specialAnim', true);
		setProperty('dad.specialAnim', true);
		cameraShake('camGame', 0.01, 0.2)
	end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Warning Note' then
		playSound('shooters', 1);
		characterPlayAnim('dad', 'shoot', true);
		cameraShake('camGame', 0.01, 0.2)
	end
end