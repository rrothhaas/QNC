% Example 1: Quantal Release
% Rebecca Rothhaas 2020-01-24

%% Exercise 1
% Assume that there are 10 quanta available in a nerve terminal, and for a
% given release event each is released with a probability of 0.2. For one
% such event, what is the probability that 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, or
% 10 quanta will be released?

n = 10; % available quanta
probabilityRelease = 0.2; % probabilty of release
k = 0:10; % quanta that will be released (0 through 10)
probs = binopdf(k,n,probabilityRelease) % probability of obtaining each value of k

% output: prob =    0.1074    0.2684    0.3020    0.2013    0.0881    0.0264    0.0055    0.0008    0.0001    0.0000    0.0000

%% Exercise 2
% Let's say you know that a given nerve terminal contains exactly 14 quanta
% available for release. You have read in the literature that the release
% probability of these quanta is low, say 0.1. To assess whether this value
% is reasonable, you run a simple experiment: activate the nerve and
% measure the number of quanta that are released. The result is 8 quanta.
% What is the probability that you would get this result (8 quanta) if the
% true probability of release really was 0.1? What about if the true
% release probability was much higher; say, 0.7? What about for each decile
% of release probability (0.1, 0.2, ... 1.0)? Which value of release
% probability did you determine to be the most probable, given your
% measurement?

n = 14; % available quanta
k = 8; % quanta that will be released 
probabilityRelease = 0.1:0.1:1; % probabilty of release (0.1 through 1.0)
probs = binopdf(k,n,probabilityRelease) % probability of obtaining k given each release probability

% output: prob =    0.0000    0.0020    0.0232    0.0918    0.1833    0.2066    0.1262    0.0322    0.0013         0
% most probably: probabilityRelease = 0.6, prob = 0.2066

%% Exercise 3
% Not feeling convinced by your single experiment (good scientist!), you
% repeat it under identical conditions. This time you measure 5 quanta that
% were released. Your sample size has now doubled, to two measurements. You
% now want to take into account both measurements when you assess the
% likelihoods of different possible values of the underlying release
% probability. To do so, assume that the two measurements in this sample
% are independent of one another; that is, the value of each result had no
% bearing on the other. In this case, the total likelihood is simply the
% product of the likelihoods associated with each separate measurement. It
% is also typical to compute the logarithm of each likelihood and take
% their sum, which is often more convenient (Links to an external site.).
% What are the values of the total likelihood and total log-likelihood in
% this example, if we assume that the true release probability is 0.1?

n = 14; % available quanta
k1 = 8; % measured number of released quanta, from previous experiment
k2 = 5; % measured number of released quanta, from repeat experiment 
probabilityRelease = 0.1; % probability of release
prob1 = binopdf(k1,n,probabilityRelease) % probabilty of obtaining k1 
prob2 = binopdf(k2,n,probabilityRelease) % probabilty of obtaining k2
totalProb = prob1 * prob2 % total likelihood 
totalLogProb = log(prob1) + log(prob2) % total log-likelihood 

% output: prob1 = 1.5959e-05 prob2 = 0.0078 totalProb = 1.2378e-07 totalLogProb = -15.9047

%% 
% Of course, knowing those values of the likelihood and log-likelihood is
% not particularly useful until you can compare them to the values computed
% for other possible values for the release probability, so you can
% determine which value of release probability is most likely, given the
% data. Therefore, compute the full likelihood and log-likelihood functions
% using deciles of release probability between 0 and 1. What is the maximum
% value? Can you improve your estimate by computing the functions at a
% higher resolution? How does the estimate improve as you increase the
% sample size?

n = 14; % available quanta
k1 = 8; % measured number of released quanta, from previous experiment
k2 = 5; % measured number of released quanta, from repeat experiment 

for probabilityRelease = 0:0.01:1.0
    disp(probabilityRelease)
    prob1 = binopdf(k1,n,probabilityRelease) % probabilty of obtaining k1 
    prob2 = binopdf(k2,n,probabilityRelease) % probabilty of obtaining k2
    totalProb = prob1 * prob2 % total likelihood 
    totalLogProb = log(prob1) + log(prob2) % total log-likelihood 
end
% output: a whole lot of data; how to find maximum?

% higher resolution
for probabilityRelease = 0:0.001:1.0
    disp(probabilityRelease)
    prob1 = binopdf(k1,n,probabilityRelease) % probabilty of obtaining k1 
    prob2 = binopdf(k2,n,probabilityRelease) % probabilty of obtaining k2
    totalProb = prob1 * prob2 % total likelihood 
    totalLogProb = log(prob1) + log(prob2) % total log-likelihood 
end

% increase sample size
probabilityRelease = 0.1;
for k = 0:n
    disp(k)
    prob1 = binopdf(k1,n,probabilityRelease) % probabilty of obtaining k1 
    prob2 = binopdf(k2,n,probabilityRelease) % probabilty of obtaining k2
    totalProb = prob1 * prob2 % total likelihood 
    totalLogProb = log(prob1) + log(prob2) % total log-likelihood 
end

%% Exercise 4
% You keep going and conduct 100 separate experiments and end up with these
% results: [table] What is the most likely value of p (which we typically
% refer to as LaTeX: \hat{p}p ^, which is pronounced as "p-hat" and
% represents the maximum-likelihood estimate (Links to an external site.)
% of a parameter in the population given our sample with a resolution of
% 0.01?

counts = [0	0 3 10 19 26 16 16 5 5 0 0 0 0 0]; % from table
n = length(counts)-1;
k = 0:n;
lengthk = length(k); 
probabilityRelease = (0:0.01:1.0)';
lengthpr = length(probabilityRelease);

probs = binopdf( ... % Calculate the binomial distribution for each possible value of n, k, and probabilityRelease
    repmat(k, lengthpr, 1), ...    % calculate for each volume of p
    n, ...                     % calculate for n
    repmat(probabilityRelease, 1, lengthk));       % calculate for each value of k

countsMatrix = repmat(counts, lengthpr, 1); % create outcome matrix 

likelihoodFcn = prod(probs.^countsMatrix,2); % likelihood function
pHat_fromLiklihood = probabilityRelease(likelihoodFcn==max(likelihoodFcn)) % p-hat for likelihood function; output 0.3800

logLikelihoodFcn = sum(log(probs).*countsMatrix,2); % same but for log likelihood
pHat_fromLogLikelihood = probabilityRelease(logLikelihoodFcn==max(logLikelihoodFcn)) % output 0.3800

pHat = binofit(sum(counts.*k),sum(counts)*n) % calculate p-hat; output 0.3821

%% Exercise 5
% Let's say that you have run an exhaustive set of experiments on this
% synapse and have determined that the true release probability is 0.3
% (within some very small tolerance). Now you want to test whether changing
% the temperature of the preparation affects the release probability. So
% you change the temperature, perform the experiment, and measure 7 quantal
% events for the same 14 available quanta. Compute LaTeX: \hat{p}p ^.
% Standard statistical inference now asks the question, what is the
% probability that you would have obtained that measurement given a Null
% (Links to an external site.)Hypothesis of no effect? In this case, no
% effect corresponds to an unchanged value of the true release probability
% (i.e., its value remained at 0.3 even with the temperature change). What
% is the probability that you would have gotten that measurement if your
% Null Hypothesis were true? Can you conclude that temperature had an
% effect?

n = 14; % available quanta
k = 7; % quanta that was released 
pHat = binofit(k,n) % p-hat (maximum-likelihood estimate)
pNull = 0.3; % null hypothesis (release probability remains at 0.3)
probs = binopdf(k,n,pNull) % probability if null hypothesis is true

% output: pHat = 0.5000 prob = 0.0618