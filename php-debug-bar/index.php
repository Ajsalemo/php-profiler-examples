<?php

    require __DIR__.'/vendor/autoload.php';

    use DebugBar\StandardDebugBar;

    $debugbar = new StandardDebugBar();
    $debugbarRenderer = $debugbar->getJavascriptRenderer();

    $debugbar["messages"]->addMessage("hello world!");
?>

<html>
    <head>
        <?php echo $debugbarRenderer->renderHead() ?>
    </head>
    <body>
        <?php
            // This mimics a long running operation
            $debugbar['time']->startMeasure('longop', 'My long operation');
            sleep(5);
            $debugbar['time']->stopMeasure('longop');
            // This mimics a long running operation
            $debugbar['time']->measure('My long operation', function() {
                sleep(2);
            });
            
            echo "azure-webapps-linux-php-php-debugbar";
            echo $debugbarRenderer->render()
        ?>
    </body>
</html> -?addMessage
