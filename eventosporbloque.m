function [ alinear,eventos,eventofinal,texto ] = eventosporbloque( eventoinicio )
caso1='manosFijasIni';
caso2='touchIni';
caso3='robMovIni';
    if strcmp(eventoinicio,caso1)
            alinear = 1;
            eventos = [1,2,3,4];
            eventofinal = 4;
            texto = 'Wait';
    elseif strcmp(eventoinicio,caso2)
            alinear = 4;
            eventos = [4,10];
            eventofinal = 10;
            texto = 'Contact';
    elseif strcmp(eventoinicio,caso3)
            alinear = 10;
            eventos = [5,6,7,8,9,10,11];
            eventofinal = 9;
            texto = 'Stim On';
    else
       error('nel, esto no se puede')
    end
end

