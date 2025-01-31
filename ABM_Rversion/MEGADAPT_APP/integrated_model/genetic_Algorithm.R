#genetic Algorithm
################################################
#evaluation function
evalFunc <- function(ch) {
  
  
  return(-(sum( ss_A1_D[which(ch==1)])+sum(ss_A2_D[which(ch==2)])+sum(ss_A1_Ab[which(ch==3)])+sum(ss_A2_Ab[which(ch==4)])))
  
}


run_GA<-function(){
  chrom<-rep(1,length(ss_A1_D))
  length_total=length(chrom)
  
    
  best_strategyC<-EvolutionStrategy.int(genomeLen = length_total, 
                                        genomeMin = rep(1,length_total), 
                                        genomeMax = rep(4,length_total), 
                                        evalFunc = evalFunc,iterations = 400,popSize = 300)
  
return(best_strategyC$best$genome)
}

#####################################################################################################
#run genetic algorithm


