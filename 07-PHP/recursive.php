<?php

class Node {
    public $name, $weight;
    public $children = [];
    public $parent = null;

    function calculateWeight() {
        $w = $this->weight;
        foreach ($this->children as $child) {
            $w = $w +$child->calculateWeight();
        }
        return $w;
    }
}

$nodes = array();

while($f = fgets(STDIN)){
    $matches = array();
    preg_match('/([a-z]+) \(([0-9]+)\)( -> )?([a-z, ]+)*/', $f, $matches);

    $node = new Node();

    if (!array_key_exists($matches[1], $nodes)){
        $nodes[$matches[1]] = $node;
    } else {
        $node = $nodes[$matches[1]];
    }
    $node->name = $matches[1];
    $node->weight = $matches[2];

    if (sizeof($matches) > 3) {
        $children = array();
        $children = preg_split('/[\s,]/', $matches[4]);
        foreach ($children as $child) {
            if (!array_key_exists($child, $nodes)) {
                $nodes[$child] = new Node();
            }
            $node->children[] = $nodes[$child];
            $nodes[$child]->parent = $node;
        }
    }
}

$seeker = current($nodes);

while ($seeker->parent != null) {
    $seeker = $seeker->parent;
}

echo "$seeker->name\n";

function correct_weight($node) {
    $normalWeight = 0;
    $weirdWeight = 0;
    $normalNode = null;
    $weirdNode = null;
    foreach ($node->children as $child) {
        $weight = $child->calculateWeight();
        echo "node: $child->name  weight: $weight direct: $child->weight\n";
        if ($weight < 1) { //BLACK MAGIC AVOIDANCE
            continue;
        }
        if ($normalWeight == 0) {
            $normalWeight = $weight;
            $normalNode = $child;
        } elseif ($weight != $normalWeight){
            if ($weight == $weirdWeight) {
                $weirdWeight = $normalWeight;
                $normalWeight = $weight;
                $weirdNode = $normalNode;
                $normalNode = $child;
            } else {
                $weirdWeight = $weight;
                $weirdNode = $child;
            }
            echo "$weirdWeight\n";
        }
        echo $normalNode->name, " -> $normalWeight\n";
        echo $weirdNode->name, " -> $weirdWeight\n";
    }

    echo "\n\n";

    if ($weirdNode == null) {
        return 0;
    } else {
        $corrected = correct_weight($weirdNode);
        if ($corrected > 0) {
            return $corrected;
        } else {
            return $weirdNode->weight + ($normalWeight - $weirdWeight);
        }
    }
}

$correct_weight = correct_weight($seeker);

echo "$correct_weight\n"

?>
