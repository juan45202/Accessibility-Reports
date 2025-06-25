<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Accessibility Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; padding: 0; }
        h1 { color: #4CAF50; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        table, th, td { border: 1px solid black; }
        th, td { padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; position: sticky; top: 0}
        tr:nth-child(even) {
            background-color: #dddddd;
        }
        .violation { color: #f44336; }


        .accordion {
            background-color: #eee;
            color: #444;
            cursor: pointer;
            padding: 18px;
            width: 100%;
            border: none;
            text-align: left;
            outline: none;
            font-size: 15px;
            transition: 0.4s;
        }

        .active, .accordion:hover, .accordion:focus {
            background-color: #ccc;
        }

        .panel {
            padding: 0 18px;
            display: none;
            background-color: white;
            overflow: hidden;
        }
    </style>
</head>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
<script type="text/javascript" src="https://unpkg.com/rxjs/bundles/rxjs.umd.min.js"></script>
<body>
<h1 tabindex="0">ACCESSIBILITY REPORT</h1>

<div style="display: flex">
        <!-- Contar el número total de nodos afectados -->
        <#assign nodesTotal = 0>
        <#list violations as violation>
            <#assign nodesTotal = nodesTotal + violation.nodes?size>
        </#list>
        <!-- Contar el número total de nodos que pasaron -->
        <#assign passesTotal = 0>
        <#list passes as pass>
            <#assign passesTotal = passesTotal + pass.nodes?size>
        </#list>
        <!-- Contar el número total de nodos incompletos -->
        <#assign incompleteTotal = 0>
        <#list incomplete as incompleteItem>
            <#assign incompleteTotal = incompleteTotal + incompleteItem.nodes?size>
        </#list>
        <!-- Contar el número total de nodos inaplicables -->
        <#assign inapplicableTotal = 0>
        <#list inapplicable as inapplicableItem>
            <#assign inapplicableTotal = inapplicableTotal + 1>
        </#list>
        <div>
            <h2> URL: ${url} </h2>
            <h2> TIMESTAMP: ${timestamp} </h2>
            <h2 tabindex="0" style="display: flex"><span style="width: 20px; background-color: #b91e47;"> </span> Accessibility Passes: <span id="passesTotal"> ${passesTotal} </span> </h2>
            <h2 tabindex="0" style="display: flex"><span style="width: 20px; background-color: #00aba9;"> </span> Accessibility Violations: <span id="violationsTotal"> ${nodesTotal} </span> </h2>
            <h2 tabindex="0" style="display: flex"><span style="width: 20px; background-color: #2b5797;"> </span> Accessibility Incomplete: <span id="incompleteTotal"> ${incompleteTotal} </span> </h2>
            <h2 tabindex="0">Accessibility Inapplicable Rules: <span id="inapplicableTotal"> ${inapplicableTotal} </span> </h2>
        </div>

        <canvas id="pieChart" style="max-height: 400px; max-width: 400px"></canvas>
    </div>
    <#if violations?size == 0>
        <p>No accessibility violations were found.</p>
    <#else>
        <#assign violationsIndex = 0>
        <button class="accordion">Violations</button>
        <div class="panel" id="violationsTable" style="max-height: 500px; overflow: auto">
            <table style="overflow-x:auto">
                <tr>
                    <th>Index</th>
                    <th>Help</th>
                    <th>Description</th>
                    <th>Impact</th>
                    <th>Path (XPath)</th>
                    <th>Possible Fixes</th>
                    <th>Tags</th>
                </tr>
                <#list violations as result>
                    <#list result.nodes as node>
                        <tr>
                            <#assign violationsIndex = violationsIndex + 1>
                            <td>${violationsIndex}</td>
                            <td>${result.help} <a href="${result.helpUrl}" target="_blank" rel="noopener noreferrer">${result.helpUrl}</a></td>
                            <td id="descriptionTest" class="violation">${result.description?replace('<', '')?replace('>','')}</td>
                            <td>${node.impact}</td>
                            <td>${node.target?join(" > ")}</td>
                            <td>${node.failureSummary}</td>
                            <td>
                                <ul>
                                    <#list result.tags as tag>
                                        <li>${tag}</li>
                                    </#list>
                                </ul>
                            </td>
                        </tr>
                    </#list>
                </#list>
            </table>
        </div>
    </#if>
    <#if incomplete?size == 0>
        <p>No incomplete accessibilities were found.</p>
    <#else>
        <#assign incompleteIndex = 0>
        <button class="accordion">Incomplete</button>
        <div class="panel" id="incompleteTable" style="max-height: 500px; overflow: auto">
            <table style="overflow-x:auto">
                <tr>
                    <th>Index</th>
                    <th>Help</th>
                    <th>Description</th>
                    <th>Impact</th>
                    <th>Path (XPath)</th>
                    <th>Possible Fixes</th>
                    <th>Tags</th>
                </tr>
                <#list incomplete as result>
                    <#list result.nodes as node>
                        <tr>
                            <#assign incompleteIndex = incompleteIndex + 1>
                            <td>${incompleteIndex}</td>
                            <td>${result.help} <a href="${result.helpUrl}" target="_blank" rel="noopener noreferrer">${result.helpUrl}</a></td>
                            <td class="violation"> ${result.description?replace('<', '')?replace('>','')}</td>
                            <td>${node.impact}</td>
                            <td>${node.target?join(" > ")}</td>
                            <td>${node.failureSummary}</td>
                            <td>
                                <ul>
                                    <#list result.tags as tag>
                                        <li>${tag}</li>
                                    </#list>
                                </ul>
                            </td>
                        </tr>
                    </#list>
                </#list>
            </table>
        </div>
    </#if>
    <#if passes?size == 0>
        <p>No accessibility Passes were found.</p>
    <#else>
        <#assign passesIndex = 0>
        <button class="accordion">Passes</button>
        <div class="panel" id="passesTable" style="max-height: 500px; overflow: auto">
            <table style="overflow-x:auto">
                <tr>
                    <th>Index</th>
                    <th>Help</th>
                    <th>Description</th>
                    <th>Path (XPath)</th>
                    <th>Tags</th>
                </tr>
                <#list passes as result>
                    <#list result.nodes as node>
                        <tr>
                            <#assign passesIndex = passesIndex + 1>
                            <td>${passesIndex}</td>
                            <td tabindex="0" headers="Help">${result.help?replace('<', '')?replace('>','')} <a href="${result.helpUrl}" target="_blank" rel="noopener noreferrer">${result.helpUrl}</a></td>
                            <td tabindex="0" headers="Description" class="violation">${result.description?replace('<', '')?replace('>','')}</td>
                            <td tabindex="0" headers="Path">${node.target?join(" > ")}</td>
                            <td tabindex="0" headers="Tags">
                                <ul>
                                    <#list result.tags as tag>
                                        <li>${tag}</li>
                                    </#list>
                                </ul>
                            </td>
                        </tr>
                    </#list>
                </#list>
            </table>
        </div>
    </#if>
    <#if inapplicable?size == 0>
        <p>No inapplicable accessibilities were found.</p>
    <#else>
        <#assign inapplicableIndex = 0>
        <button class="accordion">Inapplicable</button>
        <div class="panel" id="inapplicableTable" style="max-height: 500px; overflow: auto">
            <table style="overflow-x:auto">
                <tr>
                    <th scope="col">Index</th>
                    <th scope="col">Help</th>
                    <th scope="col">Description</th>
                    <th scope="col">Tags</th>
                </tr>
                <#list inapplicable as result>
                    <tr>
                        <#assign inapplicableIndex = inapplicableIndex + 1>
                        <td>${inapplicableIndex}</td>
                        <td headers="Help"> <div>${result.help?replace('<', '')?replace('>','')} <a href="${result.helpUrl}" target="_blank" rel="noopener noreferrer">${result.helpUrl}</a></div></td>
                        <td headers="Description" class="violation"> ${result.description?replace('<', '')?replace('>','')}</td>
                        <td headers="Tags">
                            <ul>
                                <#list result.tags as tag>
                                    <li>${tag}</li>
                                </#list>
                            </ul>
                        </td>
                    </tr>
                </#list>
            </table>
        </div>
    </#if>

<script>
    var acc = document.getElementsByClassName("accordion");
    var i;

    for (i = 0; i < acc.length; i++) {
        acc[i].addEventListener("click", function() {
            this.classList.toggle("active");
            var panel = this.nextElementSibling;
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        });
    }

    const barColors = ["#b91e47", "#00aba9", "#2b5797"];
    new Chart("pieChart", {
        type: "pie",
        data: {
            labels: ["passes", "violations", "incomplete"],
            datasets: [
                {
                    backgroundColor: barColors,
                    data: [parseInt(document.getElementById('passesTotal').innerHTML.replace(',', '').replace('.', '')), parseInt(document.getElementById('violationsTotal').innerHTML.replace(',', '').replace('.', '')), parseInt(document.getElementById('incompleteTotal').innerHTML.replace(',', '').replace('.', ''))]
                },
            ],
        },
        options: {
            plugins: {
                legend: {
                    labels: {
                        font: {
                            size: 50,
                        }
                    },
                    tooltip: {
                        enabled: false,
                        bodyFont: {
                            size: 50,
                        }
                    }
                }
            }
        }
    });

</script>

</body>
</html>