clear all
clc
%load('product_23.mat')
load('product_23.mat')
minim=10^10;
TethaMinim=[];
MMinim=0;
%daca nap>5, intra in supraantrenare
%daca nap>8, crapa programul
%_________PENTRU A RESPECTA CERINTELE INITIALE, AVEM NEVOIE DE NAP=2________
nap = 5;%nap=p => polinom de grad p-1
%afisam datele initiale din product_23
plot(time, y,'k'), title('Date de intrare - product23'), xlabel('t'), ylabel('y'), grid
figure
% utilizam o bucla for pentru a calcula tetha si eroarea pentru fiecare valoare a lui M
for M=1:8

    %selectam 80% din datele initiale
    NumberT=round(length(time)*80/100);

    %formam matricea PHI = Xf pentru primele 86 de date (80%)
    Xf=[];
    %k cuprinde indecsii pentru datele de identificare
    for k=1:86
        X1=[ MP(k,nap)];%formam componenta liniara, un polinom de grad nap-1
        for m=1:M
            X1 = [X1 cos(2*pi*m*k/12) sin(2*pi*m*k/12)];% alipim componenta armonica
        end
        Xf = [Xf;X1];%alipim linia formata si trecem la urmatoarea linie pentru urmatorul k

    end
    %phi
    Xf;

    %date identificare
    for i=1:86
        y1(i)=y(i);
    end
    %aflam tetha
    Tetha = linsolve(Xf,y1');
    %date validare
    for i=1:23
        y2(i)=y(i+85);
    end

    %afisam functia aproximata pentru ultima valoare a lui Tetha folosind 80% din datele initiale si comparam cu
    %datele de identificare
    plot(1:86,f(1:86,M,Tetha,nap),'r',1:86,y(1:86),'k'),title('Identificare'),
    legend('Functia aproximata', '80% din datele initiale'), xlabel('t'), ylabel('y'), grid
    %calculam eroarea pentru datele de identificare si o memoram intr-un
    %vector, MSE_identificare
    e = 0;
    for i = 1:86
        e = e + ( y(i)-f(i,M,Tetha,nap) )^2;
    end


    MSE_id = e/(length(1:86));
    MSE_identificare(M)=MSE_id;
    %calculam eroarea pentru datele de validare si o memoram intr-un
    %vector, MSE_validare
    e = 0;
    for i = 86:108
        e = e + ( y(i)-f(i,M,Tetha,nap) )^2;
    end

    k=86:108;

    MSE_val = e/(length(k));
    MSE_validare(M)=MSE_val;

    %aflam M minim pentru a afisa graficul pentru acel M, memoram si Tetha
    %pentru M minim
    if minim>MSE_validare(M)
        minim=MSE_validare(M);
        MMinim=M;
        TethaMinim= Tetha;
    end

end
%afisam functia aproximata pentru M minim folosind 80% din datele initiale si comparam cu datele de
%identificar
figure
plot(1:86,f(1:86,MMinim,TethaMinim,nap),'r',1:86,y(1:86),'k'),title('Identificare'),
legend('Functia aproximata pentru M MINIM', '80% din datele initiale'), xlabel('t'), ylabel('y'), grid
%afisam functia aproximata pentru ultimul M, folosind 20% din datele
%initiale si comparam cu datele de validare
figure
plot(87:108,f(87:108,M,Tetha,nap),'r',87:108,y(87:108),'k'),title('Validare pt ultimul M'),
legend('Functia aproximata', '20% din datele initiale'), xlabel('t'), ylabel('y'), grid
%afisam vectorul de erori atat pentru identificare, cat si pentru validare
%afisam functia aproximata pentru  M minim folosind 20% din datele initiale si comparam cu datele de
%validare
figure
plot(87:108,f(87:108,MMinim,TethaMinim,nap),'r',87:108,y(87:108),'k'),title('Validare; M minim'),
legend('Functia aproximata', '20% din datele initiale'), xlabel('t'), ylabel('y'), grid
figure
subplot(2,1,1),plot(1:M,MSE_identificare,'m','LineWidth',1), title('MSE in functie de M - identificare'), xlabel('M'), ylabel('MSE'), grid
subplot(2,1,2),plot(1:M,MSE_validare, 'm','LineWidth',1), title('MSE in functie de M - validare'), xlabel('M'), ylabel('MSE'), grid
figure 
plot(1:86,y(1:86),'m',86:108,y(86:108),'k'),title("Date initiale"),legend("Date identificare","Date validare"),xlabel("time"),ylabel("y")
%afisare MSE minim pt identificare, validare si M minim

minim_identificare = min(MSE_identificare)
minim_validare = min(MSE_validare)
MMinim



%~~~~~~~~~~~~~~~~Functie pentru crearea polinomului~~~~~~~~~~~~~~

function o = MP(k,n)
o=[];
for i=1:n
    o=[o k^(i-1)];%construim polinomul de grad n-1
end
end

%~~~~~~~~~~~~~~~~Functie pentru functia aproximata yhead~~~~~~~~~~~~~~
function yhead = f(time, m, tetha,n)
yhead=0;

for i=1:n

    yhead=yhead+tetha(i)*time.^(i-1);%construim componenta liniara

end
for i=1:m

    yhead=yhead+cos(2*pi*i*time/12)*tetha(2*i+n-1)+sin(2*pi*i*time/12)*tetha(2*i+n);%adaugam componenta armonica

end
end