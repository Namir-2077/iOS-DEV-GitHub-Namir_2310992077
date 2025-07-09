import UIKit
struct agentInfo {
    var name: String
    var ID: String
    var deployment: String
}
let agent1 = agentInfo(name: "Bond, James", ID: "007", deployment: "Sicily, Italy") //Here, "agent1" is an instance of "agentInfo" structure!
print("The name of the agent: \(agent1.name)")
print("This particular agent's ID: \(agent1.ID)")
print("This is where the agent is currently deployed: \(agent1.deployment)")
print("The size consumed by this particuar instance is: \(MemoryLayout<agentInfo>.size) bytes")

var agent2 = agentInfo(name: "H, William", ID: "009", deployment: "Naples, Italy")
agent2.deployment = "Monaco"
print("The name of the agent: \(agent2.name)")
print("This particular agent's ID: \(agent2.ID)")
print("This is where the agent is currently deployed: \(agent2.deployment)")
print("The size consumed by this particuar instance is: \(MemoryLayout<agentInfo>.size) bytes")
