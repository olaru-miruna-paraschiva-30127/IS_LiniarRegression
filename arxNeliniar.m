clear
close all
load('iddata-13.mat')

%Afisam datele pentru identificare
subplot(121)
plot(id),title("Identificare")
%Afisam datele pentru validare
subplot(122)
plot(val),title("Validare")


%___NA SI NB _____
na=3;
nb=na;
%____M_____
M=3;

%initializare na optim, m optim, MSE optim si y optim pentru predictie si simulare
MINIMpredictie=10^12;
MINIMsimulare=10^12;
MINIMpredictieI=10^12;
MINIMsimulareI=10^12;
naOptimSimulare=0;
naOptimPredictie=0;
mOptimSimulare=0;
mOptimPredictie=0;
yOptimSimulare=0;
yOptimPredictie=0;
yOptimSimulareI=0;
yOptimPredictieI=0;

%in cazul in care se doreste afisarea unui anumit grafic, se specifica
%na-ul dorit, m-ul dorit, iar variabila "toate" ramane 0
%Daca se doreste afisarea tuturor graficelor, variabilei toate i se
%atribuie 1
naImpus=1;
nbImpus=naImpus;
mImpus=1;
toate=0;

%construim matricile de erori pentru orice na=nb si m care merg de la 1
%pana la valoarea data, aflam valorile lui na,nb,m, MSE si y pentru care
%modelul este optim (predictie si simulare)
for j=1:na
    for m=1:M
        [MSEip(j,m), MSEis(j,m), MSEvp(j,m), MSEvs(j,m),MINIMpredictie,MINIMsimulare,MINIMpredictieI,MINIMsimulareI,naOptimPredictie,naOptimSimulare,mOptimPredictie,mOptimSimulare,yOptimSimulare,yOptimPredictie,yOptimSimulareI,yOptimPredictieI]=functie(j,j,m,id.u,id.y,val.u,val.y,MINIMpredictie,MINIMsimulare,MINIMpredictieI,MINIMsimulareI,naOptimPredictie,naOptimSimulare,mOptimPredictie,mOptimSimulare,yOptimSimulare,yOptimPredictie,yOptimSimulareI,yOptimPredictieI,naImpus,nbImpus,mImpus,toate);
    end
end

figure
subplot(2,2,1),plot(1:length(val.y),val.y,1:length(val.y),yOptimPredictie),xlabel("Time"),ylabel("y"),legend('y real','y optim predictie'),title("Validare valori optime; na=nb="+naOptimPredictie+" m="+mOptimPredictie+" MSE="+MINIMpredictie)
subplot(2,2,3),plot(1:length(val.y),val.y,1:length(val.y),yOptimSimulare),xlabel("Time"),ylabel("y"),legend('y real','y optim simulare'),title("Validare valori optime; na=nb="+naOptimSimulare+" m="+mOptimSimulare+" MSE="+MINIMsimulare)
subplot(2,2,2),plot(1:length(id.y),id.y,1:length(id.y),yOptimPredictieI),xlabel("Time"),ylabel("y"),legend('y real','y optim predictie'),title("Identificare valori optime; na=nb="+naOptimPredictie+" m="+mOptimPredictie+" MSE="+MINIMpredictieI)
subplot(2,2,4),plot(1:length(id.y),id.y,1:length(id.y),yOptimSimulareI),xlabel("Time"),ylabel("y"),legend('y real','y optim simulare'),title("Identificare valori optime; na=nb="+naOptimSimulare+" m="+mOptimSimulare+" MSE="+MINIMsimulareI)

% afisam matricea de erori sub forma unui grafic 3d daca dimensiunile
% matricilor sunt mai mari ca 1 si sub forma de grafic 2d daca cel putin
% una dintre dimensiuni este 1

%plot 3d
[x,y]=meshgrid(1:na,1:M);

if na>1 && M>1
    figure
    subplot(2,2,1),surf(x,y,MSEip'),title("Identificare; na=nb="+na+"m="+m),xlabel("na,nb"),ylabel("m"),zlabel("MSE"),legend('MSEpredictie')
    subplot(2,2,3),surf(x,y,MSEis'),title("Identificare; na=nb="+na+"m="+m),xlabel("na,nb"),ylabel("m"),zlabel("MSE"),legend('MSEsimulare')
    subplot(2,2,2),surf(x,y,MSEvp'),title("Validare; na=nb="+na+"m="+m),xlabel("na,nb"),ylabel("m"),zlabel("MSE"),legend('MSEpredictie')
    subplot(2,2,4),surf(x,y,MSEvs'),title("Validare; na=nb="+na+"m="+m),xlabel("na,nb"),ylabel("m"),zlabel("MSE"),legend('MSEsimulare')

    %plot 2d
    %daca m>1 si na=nb=1, axa x o sa fie in functie de m, iar y o sa fie in
    %functie de MSE
    %daca m=1 si na=nb>1, axa x o sa fie in functie de na=nb
else
    if na==1 || M==1
        figure
        subplot(2,2,1),plot(MSEip),title("Identificare; na=nb="+na+"m="+m),ylabel("MSE"),legend('MSEpredictie')
        if M>1
            xlabel("m")
        else
            if na>1
                xlabel("na,nb")
            end
        end
        subplot(2,2,3),plot(MSEis),title("Identificare; na=nb="+na+"m="+m),ylabel("MSE"),legend('MSEsimulare')
        if M>1
            xlabel("m")
        else
            if na>1
                xlabel("na,nb")
            end
        end
        subplot(2,2,2),plot(MSEvp),title("Validare; na=nb="+na+"m="+m),ylabel("MSE"),legend('MSEpredictie')
        if M>1
            xlabel("m")
        else
            if na>1
                xlabel("na,nb")
            end
        end
        subplot(2,2,4),plot(MSEvs),title("Validare; na=nb="+na+"m="+m),ylabel("MSE"),legend('MSEsimulare')
        if M>1
            xlabel("m")
        else
            if na>1
                xlabel("na,nb")
            end
        end

    end
end

% functie in interiorul careia se vor realiza:
%calculul erorilor de predictie si simulare pentru validare si identificare
%predictia pentru identificare
%predictia pentru validare
%simularea pentru identificare
%simularea pentru validare
%matricea de regresori
%matricea de puteri
%vectorul de coeficienti corespunzatori regresorilor
%aflarea valorilor na,nb,m,y pentru care MSE este minima


function [MSEpredictiei ,MSEsimularei ,MSEpredictie ,MSEsimulare,MINIMpredictie,MINIMsimulare,MINIMpredictieI,MINIMsimulareI,naOptimPredictie,naOptimSimulare,mOptimPredictie,mOptimSimulare,yOptimSimulare,yOptimPredictie,yOptimSimulareI,yOptimPredictieI]=functie (na,nb,m,idu,idy,valu,valy,MINIMpredictie,MINIMsimulare,MINIMpredictieI,MINIMsimulareI,naOptimPredictie,naOptimSimulare,mOptimPredictie,mOptimSimulare,yOptimSimulare,yOptimPredictie,yOptimSimulareI,yOptimPredictieI,naImpus,nbImpus,mImpus,toate)

%vectorul de iesiri pentru identificare
for i=1:length(idu)
    iesiri_identificare(i)=idy(i);
end
%construim matricea de puteri

%construim matricea care contine toate combinatiile posibile utilizand
%elemente intre 0 si m, avand na+nb coloane, pe fiecare linia fiind expusa
%fiecare combinatie
for i=1:na+nb
    linie(i)=0;
end
contor=0;
while linie(1:na+nb)<=m
    for i=1:m+1
        contor=contor+1;
        combinatii(contor,1:na+nb)=linie;
        linie(na+nb)=linie(na+nb)+1;
        for j=na+nb-1:-1:1
            if linie(j+1)==m+1
                linie(j+1)=0;
                linie(j)=linie(j)+1;
            end
        end
    end
end

%utilizand matricea aflata anterior, construim o alta matrice care
%contine strict combinatii care au suma elementelor de pe fiecare linie
%mai mica sau egala cu 3, lasand astfel strict combinatiile de grad m
%sau mai mic ca m
contor1=0;
for i=1:length(combinatii(:,1))
    if sum(combinatii(i,1:na+nb))<=m
        contor1=contor1+1;
        s(contor1,1:na+nb)=combinatii(i,1:na+nb);
    end

end

% ordonam  matricea construita anterior dupa suma elementelor, incepand
% cu 0 si terminand cu m
contor2=0;
for k=0:m
    for ia=1:length(combinatii(:,1))
        if sum(combinatii(ia,1:na+nb))==k
            contor2=contor2+1;
            matrice_puteri(contor2,1:na+nb)=combinatii(ia,1:na+nb);
        end

    end

end


% construim matricea de regresori

iesiri_identificare=iesiri_identificare';
PHI = [];
% construim fiecare linie
for i=1:length(idy)
    phi=[];
    % construim fiecare regresor de pe linie
    for p=length(matrice_puteri(:,1)):-1:1
        phi1=1;
        % mergem pana la coloana na din matricea de puteri
        for j=1:na
            % condigtionam valoarea regresorului in functie de valoarea indexului
            % iesirii si de a puterii corespunzatoare
            if i-j<=0  && (matrice_puteri(p,j)>0)
                phi1=0;
            else
                if i-j<=0 &&  (matrice_puteri(p,j)==0)

                    phi1=1*phi1;
                else

                    if i-j>0
                        phi1=phi1*idy(i-j)^(matrice_puteri(p,j));



                    end
                end
            end
        end
        % mergem de la coloana na+1 pana la coloana nb din matricea de puteri
        for j=1:nb
            % condigtionam valoarea regresorului in functie de valoarea indexului
            % intrarii si de a puterii corespunzatoare
            if i-j<=0  && ( matrice_puteri(p,j+na)>0)
                phi1=0;
            else
                if i-j<=0 &&  (matrice_puteri(p,j+na)==0)

                    phi1=1*phi1;
                else

                    if i-j>0
                        phi1=phi1*idu(i-j)^(matrice_puteri(p,j+na));



                    end
                end
            end
        end
        %adaugam regresorul pe linie
        phi = [phi phi1];

    end
    %adaugam linia in matrice
    PHI = [PHI ;phi];
end

%aflam vectorul de coeficienti ai regresorilor
Theta=PHI\iesiri_identificare;



%construim predictia pentru validare
for i=1:length(valy)
    y(i)=functie_NARX(Theta,valu,valy,na,nb,i,matrice_puteri);
end


%construim simularea pentru validare
ys(1)=0;
for i=2:length(valy)

    ys(i)=functie_NARX(Theta,valu,ys(1:i-1),na,nb,i,matrice_puteri);
end


%construim predictia pentru identificare
for i=1:length(idy)
    yi(i)=functie_NARX(Theta,idu,idy,na,nb,i,matrice_puteri);
end


%construim simularea pentru identificare
ysi(1)=0;
for i=2:length(idy)

    ysi(i)=functie_NARX(Theta,idu,ysi(1:i-1),na,nb,i,matrice_puteri);
end



%aflam MSE a simularii pentru validare
MSEsimulare=0;
for i=1:length(valy)
    MSEsimulare=MSEsimulare+(valy(i)-ys(i))^2;
end
MSEsimulare=MSEsimulare/length(valy);


%aflam MSE a predictiei pentru validare
MSEpredictie=0;
for i=1:length(valy)
    MSEpredictie=MSEpredictie+(valy(i)-y(i))^2;
end
MSEpredictie=MSEpredictie/length(valy);


%aflam MSE a simularii pentru identificare
MSEsimularei=0;
for i=1:length(idy)
    MSEsimularei=MSEsimularei+(idy(i)-ysi(i))^2;
end
MSEsimularei=MSEsimularei/length(idy);
%aflam MSE a predictiei pentru identificare
MSEpredictiei=0;
for i=1:length(idy)
    MSEpredictiei=MSEpredictiei+(idy(i)-yi(i))^2;
end
MSEpredictiei=MSEpredictiei/length(idy);

%aflam na, nb, m si y pentru care aveam cele mai mici erori la simulare si
%predictie
if MINIMpredictie>MSEpredictie
    MINIMpredictie=MSEpredictie;
    MINIMpredictieI=MSEpredictiei;
    naOptimPredictie=na;
    mOptimPredictie=m;
    yOptimPredictie=y;
    yOptimPredictieI=yi;

end
if MINIMsimulare>MSEsimulare
    MINIMsimulare=MSEsimulare;
    MINIMsimulareI=MSEsimularei;
    naOptimSimulare=na;
    mOptimSimulare=m;
    yOptimSimulare=ys;
    yOptimSimulareI=ysi;


end
%conditionare afisare grafice pentru modele
if (na==naImpus && nb==nbImpus && m==mImpus) || toate==1

    figure

    subplot(2,2,1),plot(1:length(valy),valy,1:length(valu),ys(1:length(valy))),title("Validare: MSEsimulare="+MSEsimulare+" ; na="+na+" nb="+nb+" m="+m),legend('y real','y simulare'),xlabel("time"),ylabel("y")
    subplot(2,2,3),plot(1:length(valy),valy,1:length(valu),y(1:length(valy))),title("Validare: MSEpredictie="+MSEpredictie+" ; na="+na+" nb="+nb+" m="+m),legend('y real','y predictie'),xlabel("time"),ylabel("y")
    subplot(2,2,2),plot(1:length(idy),idy,1:length(idu),ysi(1:length(idy))),title("Identificare: MSEsimulare="+MSEsimularei+" ; na="+na+" nb="+nb+" m="+m),legend('y real','y simulare'),xlabel("time"),ylabel("y")
    subplot(2,2,4),plot(1:length(idy),idy,1:length(idu),yi(1:length(idy))),title("Identificare: MSEpredictie="+MSEpredictiei+" ; na="+na+" nb="+nb+" m="+m),legend('y real','y predictie'),xlabel("time"),ylabel("y")
end

end



% functie pentru realizarea NARX
function PHI1=functie_NARX(h,input,output,na,nb,k,matrice_puteri)
PHI1=0;
phi=[];
% construim vectorul de regresori
for p=length(matrice_puteri(:,1)):-1:1
    phi1=1;
    % mergem pana la coloana na din matricea de puteri
    for j=1:na
        % condigtionam valoarea regresorului in functie de valoarea indexului
        % iesirii si de a puterii corespunzatoare
        if k-j<=0  && (matrice_puteri(p,j)>0 )
            phi1=0;
        else
            if k-j<=0 && (matrice_puteri(p,j)==0)

                phi1=1*phi1;
            else

                if k-j>0
                    phi1=phi1*output(k-j)^(matrice_puteri(p,j));
                end
            end

        end
    end

    % mergem de la coloana na+1 pana la coloana nb din matricea de puteri
    for j=1:nb
        % condigtionam valoarea regresorului in functie de valoarea indexului
        % intrarii si de a puterii corespunzatoare
        if k-j<=0  && (matrice_puteri(p,j+na)>0)
            phi1=0;
        else
            if k-j<=0 &&  ( matrice_puteri(p,j+na)==0)

                phi1=1*phi1;
            else
                if k-j>0
                    phi1=phi1*input(k-j)^(matrice_puteri(p,j+na));

                end
            end
        end
    end

    phi = [phi phi1];

end
%inmutim fiecare regresor cu coeficnetul corespunzator
PHI1 = phi*h;

end