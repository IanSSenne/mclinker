import "./style.css";
import * as d3 from "d3";
import * as f from "d3-force";
import dataset from "../test/report.json";

let data = { references: {}, referenceMap: {} };

if (import.meta.env.MODE === "development") {
  data = dataset;
}
console.log({ f, d3 });
let width = window.innerWidth;
let height = window.innerHeight;
let links = [];
let nodes = [];
let dataView = document.querySelector("#data");
let nodesMap = new Map();
function getColor(k) {
  if (k.startsWith("animation-controller:")) return "red";
  if (k.startsWith("animation:")) return "blue";
  if (k.startsWith("function:")) return "green";
  if (k.startsWith("function-tag")) return "cyan";
  if (k.startsWith("script:")) return "yellow";
  if (k.startsWith("dialogue:")) return "orange";
}
Object.entries(data.references).forEach(([key, value]) => {
  let idx = nodes.push({
    id: key,
    size: Math.min(32, Math.sqrt(value.length + 1)),
    x: width / 2 + Math.random() - 0.5,
    y: height / 2 + Math.random() - 0.5,
    color: getColor(key),
    refs: value,
  });
  nodesMap.set(key, idx - 1);
});

Object.entries(data.references).forEach(([key, value]) => {
  let myIdx = nodesMap.get(key);
  value.forEach((v) => {
    links.push({
      id: `${key}-${v}`,
      source: v,
      target: key,
    });
  });
});

console.log({ nodes, links });

let svg = d3
  .select("body")
  .append("svg")
  .attr("width", width)
  .attr("height", height);

window.addEventListener("resize", () => {
  width = window.innerWidth;
  height = window.innerHeight;
  svg.attr("width", width).attr("height", height);
});
let simulation = d3
  .forceSimulation(nodes)
  .force(
    "link",
    d3.forceLink(links).id((d) => d.id)
  )
  .force("charge", d3.forceManyBody())
  .force("x", d3.forceX())
  .force("y", d3.forceY())
  .force(
    "col",
    d3.forceCollide((d) => d.size * 2)
  );

// force.linkDistance(width / 2);

let link = svg
  .selectAll(".link")
  .data(links)
  .enter()
  .append("line")
  .attr("class", "link")
  .attr("stroke", "black");

let node = svg
  .selectAll(".node")
  .data(nodes)
  .enter()
  .append("circle")
  .attr("class", "node")
  .attr("fill", (d) => d.color)
  .attr("r", (d) => d.size * 2)
  .attr("data-id", (d) => d.id)
  .on("mouseover", (e, d) => {
    dataView.innerText = JSON.stringify(d, null, 2);
  })
  .on("mouseout", (e, d) => {
    dataView.innerText = "";
  });
node.call(
  d3.drag().on("start", dragstarted).on("drag", dragged).on("end", dragended)
);
simulation.on("tick", () => {
  link
    .attr("x1", (d) => d.source.x + width / 2)
    .attr("y1", (d) => d.source.y + height / 2)
    .attr("x2", (d) => d.target.x + width / 2)
    .attr("y2", (d) => d.target.y + height / 2);

  node.attr("cx", (d) => d.x + width / 2).attr("cy", (d) => d.y + height / 2);
});
// Reheat the simulation when drag starts, and fix the subject position.
function dragstarted(event) {
  if (!event.active) simulation.alphaTarget(0.3).restart();
  event.subject.fx = event.subject.x;
  event.subject.fy = event.subject.y;
}

// Update the subject (dragged node) position during drag.
function dragged(event) {
  event.subject.fx = event.x;
  event.subject.fy = event.y;
}

// Restore the target alpha so the simulation cools after dragging ends.
// Unfix the subject position now that it’s no longer being dragged.
function dragended(event) {
  if (!event.active) simulation.alphaTarget(0);
  event.subject.fx = null;
  event.subject.fy = null;
}

// When this cell is re-run, stop the previous simulation. (This doesn’t
// really matter since the target alpha is zero and the simulation will
// stop naturally, but it’s a good practice.)
// invalidation.then(() => simulation.stop());
