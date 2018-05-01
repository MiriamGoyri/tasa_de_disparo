clear all; clc;

load ('d1609231120.mat')

%%%%%%%% SE LIMPIAN LOS ARCHIVOS DE DATOS Y SE COPIAN EN UNA ESTRUCTURA FINAL %%%%%%%%

numerodecampos= fields(e.trial);

if length(numerodecampos)< 34 % Asegura que solo se usen archivos que no contienen campos repetidos
    
   continue
        
else

% Se detectan los ensayos en los que se omita la información correspondiente a la duración del estimulo (robMovIni,robMovFin) y solo se copian los ensayos con información completa

siRob = [];
contador = 1;
for uu = 1:length(e.trial)
    if ~(isempty(e.trial(uu).robMovIni));
       siRob(contador) = uu;
       contador = contador + 1;
    end
end

copiae = e; % "e" es una estructura que contiene todos los datos obtenidos de los registros electrofisiologicos
copiae.trial = copiae.trial(siRob); % trial es una estructura dentro de "e" que contiene la información del momento en el tiempo en que ocurrio cada evento de la tarea
copiae.spikes = copiae.spikes(siRob); %spikes es una estructura dentro de "e" que contiene la información del momento en el tiempo en que ocurrio un potencial de acción (contiene dicha información separada por spikes##, cada spike es una neurona diferente)
slicespikes = fieldnames(e.slice); %slice es una estructura dentro de "e" que contiene las neuronas(spikes)que contienen información correcta (de acuerdo al electrodo usado)y cada una es un vector de 0 y 1, donde 1 son ensayos con información revisada y completa y 0 son ensayos "defecto" 

% Se eliminan en slice los ensayos en los que se omita la información correspondiente a la duración del estimulo
 for ss = 1:length(slicespikes)
      if length(e.slice.(slicespikes{ss})) >= length(siRob)
         copiae.slice.(slicespikes{ss}) = copiae.slice.(slicespikes{ss})(siRob);
      else
         copiae.slice = rmfield(copiae.slice,slicespikes{ss});
      end
 end 
 
% Se eliminan los datos de eventos redundantes o ineccesarios
camposendeshuso = {'waitCueIni','anguloInicio','anguloRotacion','velocidad','tiempo','tiempoMedido','categoria','anguloTarg','respuesta','correcto','digitalInfo','timeStamp','robSignal','robTimeSec','lfp','lfpTime','cmdIni','cmdStim','movIni','movFin','stimFin','touchCueIni','touchCueFin'};
copiae.trial = rmfield(copiae.trial,camposendeshuso);
camposenuso = fieldnames(copiae.trial);
estructura = copiae.trial(:,:);

% Se convierte la estructura de eventos (copiae.trial)en matriz para que la funcion eventosporbloques se pueda usar
matrizeventos=zeros(length(estructura),length(camposenuso));
for aa=1:length(camposenuso)
    for jj=1:length(estructura)
        matrizeventos(jj,aa)=eval(['estructura(',num2str(jj),')','.',char(camposenuso{aa})]); 
    end
end

%%%%%%%% SE REALIZA LA ALINEACIÓN DE EVENTOS Y POTENCIALES DE ACCIÓN EN BLOQUES %%%%%%%%

% La función bloquesagraficar define el evento de alineación y los eventos a graficar por cada bloque
    %Bloque 1: va desde manosFijasIni(1) hasta touchIni(4)
    %Bloque 2: va desde touchIni(4) hasta robMovIni(10)
    %Bloque 3: va desde robMovIni(10) hasta targOff(9)
bloquesagraficar = {'manosFijasIni','touchIni','robMovIni'};
listaspikes = fieldnames(copiae.slice);

  FRmatriz = [];
  
% Se copian en neurona, para cada neurona, unicamente los ensayos con información slice == 1
for ii = 1:1%length(slicespikes) %For de spikes
    ensayos = e.slice.(slicespikes{ii});
    ensayosausar = find(ensayos==1);
    
    for cc = 1:3%length(bloquesagraficar)%For de bloques
    
    for pp=1:length(ensayosausar)
        neurona{pp,1} = copiae.spikes(ensayosausar(pp)).(slicespikes{ii});
    
       
        
            eventoinicio = bloquesagraficar{cc};
            [alinear,eventos,eventofinal,texto]=eventosporbloque(eventoinicio);
            alineacion = matrizeventos(:,alinear);
            ensayofinal = length(matrizeventos);
            
             %for xx = 1:ensayofinal 
                 matrizeventos(pp,:) = matrizeventos(pp,:) - alineacion(pp) ;
                 str1 = slicespikes{ii};
                 str2 = 'alineado{pp}';
                 str3 = '=(neurona{ii}) - alineacion(pp) ;';
                 s=strcat(str1,str2,str3);
                 eval(s);
             %end
            
            %%%%%%%% OBTENCIÓN DE TASA DE DISPARO Y MATRICES POR BLOQUE %%%%%%%%
            
            SpikeTimes= [slicespikes{ii},'alineado'];
            ST = eval(SpikeTimes); %Matriz que contiene los potenciales de acción en el tiempo alineados al evento indicado en "cc"
            
    end
    
            if alinear == 1
               TimeSamples = -0.5:0.1:3.5;%Indica la linea de tiempo en que se desea calcular la tasa de disparo (para cada bloque)
            elseif alinear == 4
               TimeSamples = 3.5:0.1:6.5;
            else
               TimeSamples = 6.5:0.1:10;
            end
            
            timeConstant = 0.05;% Indica el tamaño de la ventana de tiempo en ms 
    
         FR = mean(firingrate(ST,TimeSamples,'TimeConstant',timeConstant)); %Se calcula el promedio de la tasa de disparo con la función firingrate.
         desvest= std(FR);
         FRnorm = FR-mean(FR)/desvest;
         FRmatriz = [FRmatriz,FRnorm];
            
    end
end


end