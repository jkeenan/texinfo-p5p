set -x
BRANCH=blead
DEBUGGING=
ARG=$1
if [ -n $ARG ]; then
    BRANCH=$ARG
fi
ARG2 = $2
if [ $2 = 'DEBUG' ]; then
    DEBUGGING=-DDEBUGGING
    #DEBUGGING="-DDEBUGGING -D'optimize=-ggdb3' -A'optimize=-ggdb3' -A'optimize=-O0'"
fi
echo "Handling branch: $BRANCH"
HOMEDIR=/home/jkeenan
GITDIR=$HOMEDIR/gitwork/perl
TESTINGDIR=$HOMEDIR/testing
cd $TESTINGDIR
test -d $BRANCH && rm -rfv $BRANCH
BRANCHDIR=$TESTINGDIR/$BRANCH
mkdir $BRANCHDIR
cd $GITDIR
git clean -dfx
git checkout $BRANCH
PERL5OPT=      # In case you have this set, it should not be for these purposes
TEST_JOBS=8    # Set to a suitable number for parallelism on your system

./Configure -des -Dusedevel -Uversiononly -Dprefix=${BRANCHDIR} $DEBUGGING -Dman1dir=none -Dman3dir=none

make -j${TEST_JOBS} install

cd $BRANCHDIR
wget -P bin -O - http://cpansearch.perl.org/src/MIYAGAWA/App-cpanminus-1.7011/bin/cpanm | ./bin/perl - App::cpanminus
