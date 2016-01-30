# Showcase Landscaping

[Website](http://showcaselandscapingsc.com)


### Project Setup

#### Install npm to your local env 

    curl http://nodejs.org/dist/node-latest.tar.gz | tar xvz
    cd node-v*
    ./configure --prefix=$VIRTUAL_ENV
    make install
    
    npm install

#### Building Jade

    grunt jade
    

#### Serving files locally

    grunt serve


#### Project Files

The main project files are under the app/views folder. 
Some common files are used/imported from the app/mixins folder.
