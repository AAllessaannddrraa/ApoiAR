document.addEventListener("DOMContentLoaded", () => {
  const caregiverSelect = document.getElementById("support_caregiver_id");
  const skillCheckboxes = document.querySelectorAll("input[name='support[skill_ids][]']");
  const equipmentCheckboxes = document.querySelectorAll("input[name='support[equipment_ids][]']");
  const scoreDisplay = document.getElementById("score-display");
  const tooltip = document.getElementById("missing-info");

  function updateScore() {
    const supportId = caregiverSelect.dataset.supportId;
    const caregiverId = caregiverSelect.value;
    const selectedSkills = Array.from(skillCheckboxes).filter(cb => cb.checked).map(cb => cb.value);
    const selectedEquipments = Array.from(equipmentCheckboxes).filter(cb => cb.checked).map(cb => cb.value);

    fetch(`/supports/${supportId}/calculate_score?caregiver_id=${caregiverId}&skill_ids=${selectedSkills}&equipment_ids=${selectedEquipments}`, {
      headers: { Accept: "application/json" }
    })
      .then(response => response.json())
      .then(data => {
        // Atualizar o score
        scoreDisplay.textContent = `Score: ${data.score}`;
        scoreDisplay.classList.remove("text-success", "text-warning", "text-danger");
        if (data.score >= 8) scoreDisplay.classList.add("text-success");
        else if (data.score >= 5) scoreDisplay.classList.add("text-warning");
        else scoreDisplay.classList.add("text-danger");

        // Atualizar o tooltip
        tooltip.setAttribute(
          "data-original-title",
          `Missing Skills: ${data.missing_skills.join(", ") || "None"}\nMissing Equipments: ${data.missing_equipments.join(", ") || "None"}`
        );
        $(tooltip).tooltip("show"); // Atualiza o tooltip com o novo conteúdo
      })
      .catch(error => console.error("Error fetching score:", error));
  }

  if (caregiverSelect) caregiverSelect.addEventListener("change", updateScore);
  skillCheckboxes.forEach(cb => cb.addEventListener("change", updateScore));
  equipmentCheckboxes.forEach(cb => cb.addEventListener("change", updateScore));

  const draggables = document.querySelectorAll(".draggable");
  const droppables = document.querySelectorAll(".droppable");

  draggables.forEach(draggable => {
    draggable.addEventListener("dragstart", () => {
      draggable.classList.add("dragging");
    });

    draggable.addEventListener("dragend", () => {
      draggable.classList.remove("dragging");
    });
  });

  droppables.forEach(droppable => {
    droppable.addEventListener("dragover", e => {
      e.preventDefault();
      droppable.classList.add("highlight");
    });

    droppable.addEventListener("dragleave", () => {
      droppable.classList.remove("highlight");
    });

    droppable.addEventListener("drop", e => {
      e.preventDefault();
      droppable.classList.remove("highlight");

      const draggingCard = document.querySelector(".dragging");
      const caregiverId = draggingCard.dataset.id;
      const supportId = droppable.dataset.id;

      // Show modal for confirmation
      const modal = document.querySelector('#confirmationModal');
      modal.querySelector('.modal-body').textContent =
        `You are about to associate Caregiver "${draggingCard.querySelector('.card-title').textContent}" ` +
        `with Support "${droppable.querySelector('.card-title').textContent}". Confirm?`;
      modal.classList.add('active');

      // Confirm action
      document.querySelector('#confirmButton').onclick = () => {
        modal.classList.remove('active');

        // Save logic (AJAX/Backend Call Placeholder)
        fetch(`/supports/${supportId}/assign_caregiver`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content,
          },
          body: JSON.stringify({
            caregiver_id: caregiverId
          }),
        })
        .then(response => response.json())
        .then(data => {
          alert('Assignment saved!');
          location.reload(); // Reload the page to reflect changes
        })
        .catch(error => console.error('Error:', error));
      };

      // Cancel action
      document.querySelector('#cancelButton').onclick = () => {
        modal.classList.remove('active');
      };
    });
  });

  // Recalculo de Matches em Tempo Real
  document.querySelectorAll(".skill-checkbox, .equipment-checkbox").forEach((checkbox) => {
    checkbox.addEventListener("change", async (event) => {
      const supportId = event.target.closest(".support-card").dataset.id;

      try {
        const response = await fetch(`/supports/${supportId}/recalculate_matches`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          },
        });

        if (response.ok) {
          const data = await response.json();
          // Update matches dynamically
          updateMatchesUI(supportId, data.matches);
        } else {
          alert("Failed to recalculate matches.");
        }
      } catch (error) {
        console.error("Error:", error);
      }
    });
  });

  function updateMatchesUI(supportId, matches) {
    const matchesContainer = document.querySelector(`#matches-container-${supportId}`);
    matchesContainer.innerHTML = matches.map((match) =>
      `<div class="card match-card">
        <div class="card-body">
          <h5>${match.name}</h5>
          <p>Score: ${match.score}</p>
        </div>
      </div>`
    ).join("");
  }

  document.querySelector("#add-support-button").addEventListener("click", () => {
    const data = {
      name: document.querySelector("#support-name").value,
      description: document.querySelector("#support-description").value,
    };

    fetch("/supports/add_support_to_dashboard", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          // Adicione o novo suporte à lista
          const supportList = document.querySelector("#supports-list");
          const newSupportHTML = `<div class="card">
                                    <div class="card-body">
                                      <h5>${data.support.name}</h5>
                                      <p>${data.support.description}</p>
                                    </div>
                                  </div>`;
          supportList.innerHTML += newSupportHTML;
        } else {
          alert("Erro ao adicionar suporte: " + data.errors.join(", "));
        }
      });
  });

  // Auto-scroll while dragging
  document.addEventListener('dragover', (e) => {
    if (e.clientY < 100) {
      window.scrollBy(0, -10);
    } else if (e.clientY > window.innerHeight - 100) {
      window.scrollBy(0, 10);
    }
  });
});
