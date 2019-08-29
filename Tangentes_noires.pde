import processing.svg.*;

void setup(){
  size(1500,800);
  beginRecord(SVG, "file_11.svg"); 
}

/*On cherche l'ordonnee de l'abcisse donnée.
De plus, on sait que (x-xc)²+(y-yc)² = r²*/
float getYPoint(float X, int x0, int y0, int rayon){
  /*On se retrouve avec l'équation :
  Y²-Y*2y0 + y0²+ (X-x0)² - r²= 0, on cherche delta*/
  
  float delta = pow(2*y0, 2)-4*(pow(y0, 2)+pow(X-x0, 2) - pow(rayon, 2));
  if(delta>0){
    float Y = (2*y0+sqrt(delta)) / 2.0;
    return Y;
  }else if(delta==0){
     float Y = float(y0);
     return Y;
  }
  return 0;
}

float[] getEquation(float x, float y, int x0, int y0){
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

  float y = -(d[0]/d[1])*x - (d[2]/d[1]);
  
  return y;
}

void tracerDroite(PVector a, PVector b){
  line(a.x, a.y, b.x, b.y);
}

void draw(){
  /*Ecart des tangentes*/
  int ecartTangente = int(random(1, 10));
  /*On considère le triangle C de centre
  c(x0, y0) et de rayon r. On va chercher des tangentes en
  plusieurs de ses points*/
  
  int rayon = int(random(50, 300));
  int x0 = int(random(rayon, 1500-rayon));
  int y0 = int(random(rayon, 800-rayon));
  
    /*XA doit varier entre le x le plus en bas et celui le plus à droite du cercle.
    Il commence dnc à x0 et va finir en x0+rayon*/
  
    PVector a = new PVector(x0, 0);
    
  
  int nbDroitesRand = int(random(50, 300)); //Nombre de droites à dessiner
  
  for(int nbDroites=0; nbDroites<nbDroitesRand; nbDroites++){ //nbDroites est la n-ieme droite entrain d'être tracée
    
    a.y = getYPoint(a.x, x0, y0, rayon);
    
    if(a.y !=0){
    
      float[] droite = getEquation(a.x, a.y, x0, y0);
      
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
      
      tracerDroite (p1, p2);
    }
    
    a.x += ecartTangente;
  } 
  
  noLoop();
  
 endRecord();
 exit();
}
