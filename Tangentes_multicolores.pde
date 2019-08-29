import processing.svg.*;

void setup(){
  size(1500,800);
  background(0);
  beginRecord(SVG, "file_10.svg"); 
}

/*On considère le triangle C de centre
c(x0, y0) et de rayon r. On va chercher des tangentes en
plusieurs de ses points*/

int rayon = int(random(50, 300));
int x0 = int(random(rayon, 1500-rayon));
int y0 = int(random(rayon, 800-rayon));
int ecartTangente = int(random(1, 10));
  
/*On cherche l'ordonnee de l'abcisse donnée.
De plus, on sait que (x-xc)²+(y-yc)² = r²*/
float getYA(float X){
  /*On se retrouve avec l'équation :
  Y²-Y*2y0 + y0²+ (X-x0)² - r², on cherche delta*/
  
  float delta = pow(2*y0, 2)-4*(pow(y0, 2)+pow(X-x0, 2) - pow(rayon, 2));
  if(delta>0){
    float Y = (2*y0+sqrt(delta)) / 2.0;
    return Y;
  }else if(delta==0){
     float Y = 2*y0/2.0;
     return Y;
  }
  return 0;
}

float[] getEquation(float x, float y){
  /*On sait que la droite passe par x et y.
  De plus son vecteur directeur est {x-x0, y-y0} car elle est perpendiculaire
  au rayon du cercle de centre (x0, y0).
  On cherche donc la constante en remplacant x et y
  par les x et y de A dans l'équation*/
  
  float c = -(x-x0)*x-(y-y0)*y;
  
  /*On a donc une droite d'équation ax+by+c avec 
  a = x-x0, b = y-y0, c = c*/
  
  float[] equationCoordinates = { x-x0, y-y0, c};
  
  return equationCoordinates;
}


/*On veut retourner le y, sachant que le point
doit appartenir a la droite d*/
float getY(float x, float[] d){
  /*On a une droite ax+by+c = 0 et un x,
  on a donc y = -(a/b)x -c/b*/
  //println(x+" et "+d[0]);
  float y = -(d[0]/d[1])*x - (d[2]/d[1]);
  
  return y;
}

void tracerDroite(PVector a, PVector b, Couleur colors){
  stroke(colors.c1, colors.c2, colors.c3);
  line(a.x, a.y, b.x, b.y);
}

/*Créer une structure de type couleur*/
class Couleur{
  int c1, c2, c3;
  Couleur(int a, int b, int c)  {    
    c1 = a;
    c2 = b;
    c3 = c;
  }
}

Couleur getColors(int nbDroites, int nbDroitesMax){
    Couleur couleur = new Couleur(0, 0, 0);
   
   /*On divise le nombre de droites maximum par 6 car notre arc-en-ciel
   se construiit en étant un multiple de 6
   En premier, nous somme dans le premier 6e. On va aller du rouge au jaune*/
    if(nbDroites <= (nbDroitesMax/6)){     
      /*La deuxieme couleur va de 0 à 255*/
      couleur = new Couleur(255, (255*nbDroites)/(nbDroitesMax/6), 0);
      
    }else if((nbDroites > (nbDroitesMax/6)) && (nbDroites <= (nbDroitesMax/3))){
      
      couleur = new Couleur((nbDroitesMax/3)-2*nbDroites, 255, 0);
      
    }else if((nbDroites > (nbDroitesMax/3)) && (nbDroites <= (nbDroitesMax/2))){
      
      couleur = new Couleur(0, 255, 765-2*nbDroites);
      
    }else if((nbDroites > (nbDroitesMax/2)) && (nbDroites <= (2*nbDroitesMax/3))){
      
      couleur = new Couleur(0, 1020-2*nbDroites, 255);
      
    }else if((nbDroites > (2*nbDroitesMax/3)) && (nbDroites <= (5*nbDroitesMax/6))){
      
      couleur = new Couleur(2*nbDroites-1020, 0, 255);
      
    }else if((nbDroites > (5*nbDroitesMax/6)) && (nbDroites <= nbDroitesMax)){
      
      couleur = new Couleur(255, 0, 1530-2*nbDroites);
    }

    return couleur;
}

void draw(){
  /*XA doit varier entre le x le plus a gauche et celui le plus à droite du cercle.
  Ce qui correspond à x0-r et x0+r.
  Le pas sera donc le nombre de droites, divisée par la longueur 2r*/
  
  float XA = x0-rayon;
  int nbDroitesRand = int(random(600, 1530));
  nbDroitesRand -= nbDroitesRand%6;
  boolean already = false;
  
  for(int nbDroites=0; nbDroites<nbDroitesRand; nbDroites++){
    float[] A = {XA, getYA(XA)};
    
    if(!already || (A[1] !=0)){
    
      float[] droite = getEquation(A[0], A[1]);
      
      /*On crée deux points qui vont appartenir à la droite*/
      PVector p1 = new PVector();
      PVector p2 = new PVector();
      float rand = random(0, 500);
      
      p1.set(rand, getY(rand, droite));
      /*On veut que la distance entre les deux points soit supérieure
      ou égale à 50. On obtient donc xp2 doit être un nombre entre 
      xp1+50 et 300 par exemple*/
      rand = random(p1.x+50, p1.x+500);
      p2.set(rand, getY(rand, droite));
      
      Couleur colors = new Couleur(0, 0, 0);
      
      /*On fait le dégradé, on a fait un multiple de 6*/
      colors = getColors(nbDroites+1, nbDroitesRand);
      tracerDroite (p1, p2, colors);
    }
    
    if(XA==0){
      already = true;
    }
    
    XA += ecartTangente;

  }

  noLoop();
  
 endRecord();
 exit();
}
