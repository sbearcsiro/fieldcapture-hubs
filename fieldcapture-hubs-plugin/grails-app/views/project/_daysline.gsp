<style type="text/css">
.daysline-positive {
    margin: 2px 0;
    height: 4px;
    background: lightgrey;
}
.daysline-positive > div {
    height: 4px;
    background: #337AB7;
}
.daysline-zero {
    margin: 2px 0;
    height: 4px;
    background: #65B045;
}
.daysline-infinite {
    margin: 2px 0;
    height: 4px;
}
</style>
<div class="daysline-positive" data-bind="visible:transients.daysSince() >= 0 && transients.daysRemaining() > 0">
    <div data-bind="style:{width:Math.floor(transients.daysRemaining()/transients.daysTotal() * 100) + '%'}"></div>
</div>
<div class="daysline-zero" data-bind="visible:transients.daysSince() >= 0 && transients.daysRemaining() == 0"></div>
<div class="daysline-infinite" data-bind="visible:transients.daysSince() < 0 || transients.daysRemaining() < 0"></div>
